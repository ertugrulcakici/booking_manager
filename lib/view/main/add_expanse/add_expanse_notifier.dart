import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/expanse_category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddExpanseNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<ExpanseCategoryModel> categories = [];

  Map<String, dynamic> formData = {};

  Future<void> getExpanseCategories() async {
    try {
      isLoading = true;
      categories.clear();
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection("expanse_categories")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .get();
      categories = categoriesSnapshot.docs
          .map((e) => ExpanseCategoryModel.fromJson(e.data()))
          .toList();
      formData["categoryUid"] = categories.first.uid;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> addExpanse() async {
    try {
      isLoading = true;
      final now = DateTime.now();
      final docRef = FirebaseFirestore.instance.collection("expanses").doc();
      final expanse = {
        "uid": docRef.id,
        "addedBy": AuthService.instance.user!.uid,
        "addedTime": now.millisecondsSinceEpoch,
        "lastUpdatedBy": AuthService.instance.user!.uid,
        "lastUpdatedTime": now.millisecondsSinceEpoch,
        "relatedBusinessUid": AuthService.instance.user!.relatedBusinessUid,
        ...formData
      };
      await docRef.set(expanse);
      PopupHelper.instance.showToastMessage(
          message: LocaleKeys.add_expanse_added_successfully.tr());
      NavigationService.back();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
