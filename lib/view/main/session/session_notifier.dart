import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/enums/session_history_type_enum.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_history_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SessionNotifier extends ChangeNotifier {
  List<BranchModel> branches;
  late BranchModel _selectedBranch;
  BranchModel get selectedBranch => _selectedBranch;
  set selectedBranch(BranchModel value) {
    _selectedBranch = value;
    formData["branchUid"] = value.uid;
    formData["time"] = value.workingHoursList.first;
    notifyListeners();
  }

  Map<String, dynamic> formData = {};

  // if sessionModel is null, then we are creating a new session. Otherwise, we are updating an existing session
  SessionModel? sessionModel;

  SessionNotifier(
      {this.sessionModel,
      required this.branches,
      required BranchModel selectedBranch,
      required String time,
      required String date}) {
    formData["time"] = time;
    formData["date"] = date;
    _selectedBranch = selectedBranch;
    if (sessionModel != null) {
      formData = sessionModel!.toJson();
    }
  }

  Future<void> save() async {
    try {
      formData["addedBy"] = AuthService.instance.user!.uid;
      formData["branchUid"] = selectedBranch.uid;
      formData["uid"] =
          sessionModel?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();
      SessionModel newSessionModel = SessionModel.fromJson(formData);

      newSessionModel.subTotal =
          selectedBranch.unitPrice.toDouble() * newSessionModel.personCount;
      newSessionModel.total = newSessionModel.subTotal -
          newSessionModel.discount +
          newSessionModel.extra;

      DocumentReference newDocRef = FirebaseFirestore.instance
          .collection("sessions")
          .doc(newSessionModel.uid);

      await newDocRef.set(newSessionModel.toJson());

      if (sessionModel != null &&
          !sessionModel!.isAllFieldsSame(newSessionModel)) {
        // we are creating a log for the session
        SessionHistoryModel sessionLogModel = SessionHistoryModel(
            timestamp: DateTime.now().millisecondsSinceEpoch,
            originalSession: sessionModel!,
            updatedSession: newSessionModel,
            historyType: SessionHistoryType.updated,
            relatedBusinessUid: selectedBranch.relatedBusinessUid,
            by: AuthService.instance.user!.uid);

        // we are saving the log
        await FirebaseFirestore.instance
            .collection("session_history")
            .doc(sessionLogModel.uid)
            .set(sessionLogModel.toJson());

        PopupHelper.instance.showSnackBar(
            message: LocaleKeys.session_updated_successfully.tr());
      } else {
        // we are creating a new session
        PopupHelper.instance
            .showSnackBar(message: LocaleKeys.session_added_successfully.tr());
      }

      NavigationService.back();
      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message:
              LocaleKeys.session_could_not_be_saved.tr(args: [e.toString()]));
    }
  }

  // delete session and move it to logs
  Future<void> deleteSession() async {
    try {
      await FirebaseFirestore.instance
          .collection("sessions")
          .doc(sessionModel!.uid)
          .delete();

      SessionHistoryModel sessionLogModel = SessionHistoryModel(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        originalSession: sessionModel!,
        historyType: SessionHistoryType.deleted,
        relatedBusinessUid: selectedBranch.relatedBusinessUid,
        by: AuthService.instance.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection("session_history")
          .doc(sessionLogModel.uid)
          .set(sessionLogModel.toJson());
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.session_deleted_successfully.tr());
      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message:
              LocaleKeys.session_could_not_be_deleted.tr(args: [e.toString()]));
    }
  }
}
