import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
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

      DocumentReference docRef = FirebaseFirestore.instance
          .collection("sessions")
          .doc(sessionModel?.uid);
      formData["uid"] = docRef.id;

      SessionModel newSessionModel = SessionModel.fromJson(formData);
      formData["income"] =
          selectedBranch.unitPrice * newSessionModel.personCount;
      formData["total"] =
          formData["income"] - newSessionModel.discount + newSessionModel.extra;
      await docRef.set(formData);
      PopupHelper.instance.showSnackBar(message: "Session saved successfully");
      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Session could not be saved due to an error: \n$e");
    }
  }

  Future<void> deleteSession() async {
    try {
      await FirebaseFirestore.instance
          .collection("sessions")
          .doc(sessionModel!.uid)
          .delete();
      NavigationService.back();
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Something went wrong due to: \n$e", error: true);
    }
  }
}
