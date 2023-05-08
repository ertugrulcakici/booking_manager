import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InvitationsNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<InvitationModel> invitations = [];

  String code = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> getInvitations() async {
    try {
      isLoading = true;
      invitations.clear();

      final registeredInvitations = await FirebaseFirestore.instance
          .collection("invitations")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .get();

      if (registeredInvitations.docs.isNotEmpty) {
        invitations.addAll(registeredInvitations.docs
            .map((e) => InvitationModel.fromJson(e.data())));
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> createInvitation(String value) async {
    try {
      final now = DateTime.now();
      InvitationModel invitationModel = InvitationModel(
          code: now.millisecondsSinceEpoch.toString(),
          createdDate: now.millisecondsSinceEpoch,
          forWhomName: value,
          uid: now.millisecondsSinceEpoch.toString(),
          relatedBusinessUid: AuthService.instance.user!.relatedBusinessUid);

      isLoading = true;
      DocumentReference newInvDoc = FirebaseFirestore.instance
          .collection("invitations")
          .doc(invitationModel.uid);
      await newInvDoc.set(invitationModel.toJson());
      invitations.add(invitationModel);
      PopupHelper.instance
          .showSnackBar(message: "Invitation created successfully");
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Invitation couldn't be created due to : $e", error: true);
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteInvitation(InvitationModel invitationModel) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection("invitations")
          .doc(invitationModel.uid)
          .delete();
      invitations.remove(invitationModel);
      PopupHelper.instance
          .showSnackBar(message: "Invitation deleted successfully");
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "Invitation couldn't be deleted due to : $e", error: true);
    } finally {
      isLoading = false;
    }
  }
}
