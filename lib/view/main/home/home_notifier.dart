import 'dart:async';
import 'dart:developer';

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/business_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeNotifier extends ChangeNotifier with LoadingNotifierMixin {
  BusinessModel? activeBusiness;
  // List<BranchModel> branches = [];
  Map<String, List<SessionModel>> sessions = {};

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _businessListener;
  // StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _branchesListener;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sessionsListener;

  TickerProvider viewState;
  HomeNotifier(this.viewState);

  int lastSelectedTabIndex = 0;
  TabController? tabController;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  Future<void> setSelectedDate(DateTime value) async {
    _selectedDate = value;
    await _setupSessionsListener();
    notifyListeners();
  }

  Future<void> getHomeData() async {
    try {
      isLoading = true;
      await _getBusinessData();
      // await _getBranchesData();
      await _getSessionsData();
      notifyListeners();
      await _setupListeners();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> _getBusinessData() async {
    try {
      activeBusiness = null;
      final businessDoc = await FirebaseFirestore.instance
          .collection("businesses")
          .doc(AuthService.instance.user!.relatedBusinessUid)
          .get();
      activeBusiness =
          BusinessModel.fromJson(businessDoc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> _getBranchesData() async {
  //   try {
  //     branches.clear();
  //     final branchesDocs = await FirebaseFirestore.instance
  //         .collection("branches")
  //         .where("relatedBusinessUid",
  //             isEqualTo: AuthService.instance.user!.relatedBusinessUid)
  //         .get();
  //     branches
  //         .addAll(branchesDocs.docs.map((e) => BranchModel.fromJson(e.data())));

  //     // ui
  //     _setupTab();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void _setupTab() {
    try {
      tabController?.removeListener(_tabListener);
      tabController?.dispose();
      tabController = TabController(
          length: activeBusiness!.branches.length,
          vsync: viewState,
          initialIndex: lastSelectedTabIndex);
      if (tabController!.index != lastSelectedTabIndex &&
          !tabController!.indexIsChanging) {
        tabController!.animateTo(lastSelectedTabIndex);
      }
      tabController!.addListener(_tabListener);
    } catch (e) {
      rethrow;
    }
  }

  void _tabListener() {
    lastSelectedTabIndex = tabController!.index;
  }

  Future<void> _getSessionsData() async {
    try {
      sessions.clear();
      for (var branch in activeBusiness!.branches) {
        final sessionsDocs = await FirebaseFirestore.instance
            .collection("sessions")
            .where("branchUid", isEqualTo: branch.uid)
            .where("date", isEqualTo: _selectedDate.formattedDate)
            .get();
        sessions[branch.uid] = sessionsDocs.docs
            .map((e) => SessionModel.fromJson(e.data()))
            .toList();
        log(sessions[branch.uid].toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _setupListeners() async {
    try {
      await _setupBusinessListener();
      // await _setupBranchesListener();
      await _setupSessionsListener();
    } catch (e) {
      _businessListener?.cancel();
      // _branchesListener?.cancel();
      _sessionsListener?.cancel();
      rethrow;
    }
  }

  Future<void> _setupBusinessListener() async {
    Completer<void> completer = Completer();
    _businessListener?.cancel();
    _businessListener = FirebaseFirestore.instance
        .collection("businesses")
        .doc(AuthService.instance.user!.relatedBusinessUid)
        .snapshots()
        .listen((event) async {
      isLoading = true;
      if (event.exists) {
        activeBusiness = BusinessModel.fromJson(event.data()!);
        // await _getBranchesData();
        await activeBusiness!.fetchUsers();
        await activeBusiness!.fetchBranches();
        // create branch uid in session map if not exists
        for (var element in activeBusiness!.branches) {
          sessions[element.uid] ??= [];
        }
        _setupTab();
        if (!completer.isCompleted) {
          completer.complete();
        }
        NavigationService.backToRoot();
        notifyListeners();
      } else {
        activeBusiness = null;
      }
      isLoading = false;
    });
    await completer.future;
  }

  // Future<void> _setupBranchesListener() async {
  //   _branchesListener?.cancel();
  //   _branchesListener = FirebaseFirestore.instance
  //       .collection("branches")
  //       .where("relatedBusinessUid",
  //           isEqualTo: AuthService.instance.user!.relatedBusinessUid)
  //       .snapshots()
  //       .listen((event) {
  //     isLoading = true;
  //     for (var element in event.docs) {
  //       if (element.exists) {
  //         BranchModel snapshotBranch = BranchModel.fromJson(element.data());
  //         bool ifExists =
  //             branches.any((branch) => snapshotBranch.uid == branch.uid);
  //         if (!ifExists) {
  //           branches.add(snapshotBranch);
  //         } else {
  //           int index = branches
  //               .indexWhere((branch) => snapshotBranch.uid == branch.uid);
  //           branches[index] = snapshotBranch;
  //         }
  //       } else {
  //         if (branches.any((branch) => branch.uid == element.id)) {
  //           branches.removeWhere((branch) => branch.uid == element.id);
  //         }
  //       }
  //     }
  //     isLoading = false;
  //   });
  // }

  Future<void> _setupSessionsListener() async {
    _sessionsListener?.cancel();
    _sessionsListener = FirebaseFirestore.instance
        .collection("sessions")
        .where("date", isEqualTo: _selectedDate.formattedDate)
        .snapshots()
        .listen((event) {
      isLoading = true;
      for (var docChange in event.docChanges) {
        final data = docChange.doc.data();
        log(data.toString());
        SessionModel snapshotSession =
            SessionModel.fromJson(data as Map<String, dynamic>);
        if (docChange.type == DocumentChangeType.removed) {
          sessions[snapshotSession.branchUid]!
              .removeWhere((element) => element.uid == snapshotSession.uid);
        } else if (docChange.type == DocumentChangeType.modified) {
          int index = sessions[snapshotSession.branchUid]!
              .indexWhere((element) => element.uid == snapshotSession.uid);
          sessions[snapshotSession.branchUid]![index] = snapshotSession;
        } else if (docChange.type == DocumentChangeType.added) {
          bool ifExists = sessions[snapshotSession.branchUid]!
              .any((element) => element.uid == snapshotSession.uid);
          if (!ifExists) {
            sessions[snapshotSession.branchUid]!.add(snapshotSession);
          } else {
            int index = sessions[snapshotSession.branchUid]!
                .indexWhere((element) => element.uid == snapshotSession.uid);
            sessions[snapshotSession.branchUid]![index] = snapshotSession;
          }
        }
      }
      isLoading = false;
    });
  }
}
