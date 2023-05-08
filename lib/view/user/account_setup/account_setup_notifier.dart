import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountSetupNotifier extends ChangeNotifier {
  bool _isWorker = false;
  bool get isWorker => _isWorker;
  set isWorker(bool value) {
    _isWorker = value;
    notifyListeners();
  }

  AccountSetupNotifier();

  Future<bool> joinViaCode(String code) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("invitations")
          .where("code", isEqualTo: code)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception("Invalid code");
      } else {
        InvitationModel invitation =
            InvitationModel.fromJson(querySnapshot.docs.first.data());
        final userDocRef = FirebaseFirestore.instance
            .collection("users")
            .doc(AuthService.instance.user!.uid);
        final businessDocRef = FirebaseFirestore.instance
            .collection("businesses")
            .doc(invitation.relatedBusinessUid);

        FirebaseFirestore.instance.runTransaction((transaction) {
          transaction.update(userDocRef,
              {"relatedBusinessUid": invitation.relatedBusinessUid});
          transaction.update(businessDocRef, {
            "workersUidList":
                FieldValue.arrayUnion([AuthService.instance.user!.uid])
          });
          transaction.update(
              FirebaseFirestore.instance
                  .collection("invitations")
                  .doc(querySnapshot.docs.first.id),
              {"usedDate": DateTime.now().millisecondsSinceEpoch});
          return Future.value(true);
        });
        PopupHelper.instance
            .showSnackBar(message: "You have joined the business successfully");
        return true;
      }
    } catch (e) {
      PopupHelper.instance.showSnackBar(message: e.toString());
      return false;
    }
  }
}
