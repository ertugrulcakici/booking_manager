import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/enums/session_history_type_enum.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/product/models/session_history_model.dart';
import 'package:bookingmanager/product/models/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      await newDocRef.set(formData);

      if (sessionModel != null &&
          !sessionModel!.isAllFieldsSame(newSessionModel)) {
        // we are creating a log for the session
        SessionHistoryModel sessionLogModel = SessionHistoryModel(
            timestamp: DateTime.now().millisecondsSinceEpoch,
            originalSession: sessionModel!,
            updatedSession: newSessionModel,
            logType: SessionHistoryType.updated,
            branchUid: selectedBranch.uid,
            relatedBusinessUid: selectedBranch.relatedBusinessUid,
            by: AuthService.instance.user!.uid);

        // we are saving the log
        await FirebaseFirestore.instance
            .collection("session_history")
            .doc(sessionLogModel.uid)
            .set(sessionLogModel.toJson());

        PopupHelper.instance
            .showSnackBar(message: "Session updated successfully");
      } else {
        // we are creating a new session
        PopupHelper.instance
            .showSnackBar(message: "Session saved successfully");
      }

      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Session could not be saved due to an error: \n$e");
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
        logType: SessionHistoryType.deleted,
        branchUid: selectedBranch.uid,
        relatedBusinessUid: selectedBranch.relatedBusinessUid,
        by: AuthService.instance.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection("session_history")
          .doc(sessionLogModel.uid)
          .set(sessionLogModel.toJson());
      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Something went wrong due to: \n$e", error: true);
    }
  }
}
