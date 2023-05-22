import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.invitations_invitation_created.tr());
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.invitations_invitation_could_not_be_created
              .tr(args: [e.toString()]),
          error: true);
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
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.invitations_invitation_deleted.tr());
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: LocaleKeys.invitations_invitation_could_not_be_deleted
              .tr(args: [e.toString()]),
          error: true);
    } finally {
      isLoading = false;
    }
  }
}
