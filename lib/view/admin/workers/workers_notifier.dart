import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkersNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<UserModel> users = [];

  Future<void> getUsers() async {
    try {
      isLoading = true;
      users.clear();
      final usersDocs = await FirebaseFirestore.instance
          .collection("users")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .get();
      users = usersDocs.docs.map((e) => UserModel.fromJson(e.data())).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      isLoading = true;

      final businessDocRef = FirebaseFirestore.instance
          .collection("businesses")
          .doc(AuthService.instance.user!.relatedBusinessUid);
      final userDocRef =
          FirebaseFirestore.instance.collection("users").doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) {
        transaction.update(businessDocRef, {
          "workersUidList": FieldValue.arrayRemove([user.uid]),
          "adminsUidList": FieldValue.arrayRemove([user.uid])
        });
        transaction
            .update(userDocRef, {"relatedBusinessUid": FieldValue.delete()});
        return Future.value(true);
      });
      PopupHelper.instance.showSnackBar(message: "User deleted successfully");
    } catch (e) {
      PopupHelper.instance.showSnackBar(
          message: "User couldn't be deleted due to : $e", error: true);
    } finally {
      isLoading = false;
    }
  }
}
