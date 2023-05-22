import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:bookingmanager/view/admin/branch/branch_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BranchesNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<BranchModel> branches = [];

  Future<void> getData() async {
    branches.clear();
    isLoading = true;
    try {
      QuerySnapshot value = await FirebaseFirestore.instance
          .collection("branches")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .get();

      for (var element in value.docs) {
        final branch =
            BranchModel.fromJson(element.data() as Map<String, dynamic>);
        branches.add(branch);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> addBranchNavigate() async {
    BranchModel? branch =
        await NavigationService.toPage<BranchModel>(const BranchView());
    if (branch == null) {
      return;
    }
    isLoading = true;
    try {
      DocumentReference branchReference = await FirebaseFirestore.instance
          .collection("branches")
          .add(branch.toJson());
      branch.uid = branchReference.id;
      await branchReference.set(branch.toJson());
      DocumentReference businessReference = FirebaseFirestore.instance
          .collection("businesses")
          .doc(AuthService.instance.user!.relatedBusinessUid);
      await businessReference.update({
        "branchesUidList": FieldValue.arrayUnion([branch.uid])
      });
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.branches_branch_created.tr());
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> editBranch(BranchModel branch) async {
    try {
      isLoading = true;
      BranchModel? newBranch = await NavigationService.toPage<BranchModel>(
          BranchView(branch: branch));
      if (newBranch == null) {
        return;
      }
      await FirebaseFirestore.instance
          .collection("branches")
          .doc(branch.uid)
          .set(newBranch.toJson(), SetOptions(merge: true));
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.branches_branch_updated.tr());
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteBranch(BranchModel branch) async {
    try {
      isLoading = true;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        final branchDoc =
            FirebaseFirestore.instance.collection("branches").doc(branch.uid);

        transaction.delete(branchDoc);

        final businessDoc = FirebaseFirestore.instance
            .collection("businesses")
            .doc(AuthService.instance.user!.relatedBusinessUid);

        transaction.update(businessDoc, {
          "branchesUidList": FieldValue.arrayRemove([branch.uid])
        });
        final sessionsDocs = await FirebaseFirestore.instance
            .collection("sessions")
            .where("branchUid", isEqualTo: branch.uid)
            .get();

        for (var element in sessionsDocs.docs) {
          transaction.delete(element.reference);
        }
        return Future.value(true);
      });
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.branches_deleted.tr());
    } catch (e) {
      errorMessage = e.toString();
      PopupHelper.instance
          .showSnackBar(message: LocaleKeys.branches_error_deleting.tr());
    } finally {
      isLoading = false;
    }
  }
}
