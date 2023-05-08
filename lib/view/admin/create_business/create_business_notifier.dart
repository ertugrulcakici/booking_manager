import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/business_model.dart';
import 'package:bookingmanager/view/main/home/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateBusinessNotifier extends ChangeNotifier {
  // List<BranchModel> branches = [];

  CreateBusinessNotifier();

  Future<void> save({required String businessName}) async {
    if (businessName.trim().isEmpty) {
      PopupHelper.instance.showSnackBar(message: "Business name is empty");
    }
    final BusinessModel business = BusinessModel(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        name: businessName,
        businessLogoUrl: "null",
        workersUidList: [AuthService.instance.user!.uid],
        // branchesUidList: branches.map((e) => e.uid).toList(),
        branchesUidList: [],
        adminsUidList: [AuthService.instance.user!.uid],
        ownerUid: AuthService.instance.user!.uid);

    bool? success =
        await FirebaseFirestore.instance.runTransaction<bool?>((transaction) {
      transaction.set(
          FirebaseFirestore.instance.collection("businesses").doc(business.uid),
          business.toJson());

      // for (BranchModel branch in branches) {
      //   branch.relatedBusinessUid = business.uid;
      //   transaction.set(
      //       FirebaseFirestore.instance.collection("branches").doc(branch.uid),
      //       branch.toJson());
      // }

      transaction.update(
          FirebaseFirestore.instance.collection("users").doc(business.ownerUid),
          {
            "relatedBusinessUid": business.uid,
          });
      return Future.value(true);
    });
    if (success == true) {
      NavigationService.toPageAndRemoveUntil(const HomeView());
    }
  }
}
