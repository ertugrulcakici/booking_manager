import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/expanse_category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpanseCategoriesNotifier extends ChangeNotifier
    with LoadingNotifierMixin {
  final List<ExpanseCategoryModel> categories;
  ExpanseCategoriesNotifier({required this.categories});

  Future<void> addCategory(String name) async {
    try {
      isLoading = true;
      final docRef =
          FirebaseFirestore.instance.collection("expanse_categories").doc();
      final category = ExpanseCategoryModel(
          uid: docRef.id,
          name: name,
          relatedBusinessUid: AuthService.instance.user!.relatedBusinessUid,
          addedTime: DateTime.now().millisecondsSinceEpoch,
          addedBy: AuthService.instance.user!.uid,
          lastUpdatedTime: DateTime.now().millisecondsSinceEpoch,
          lastUpdatedBy: AuthService.instance.user!.uid);
      await docRef.set(category.toJson());
      categories.add(category);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<bool> editCategoryName(
      ExpanseCategoryModel category, String newValue) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection("expanse_categories")
          .doc(category.uid)
          .update({
        "name": newValue,
        "lastUpdatedTime": DateTime.now().millisecondsSinceEpoch,
        "lastUpdatedBy": AuthService.instance.user!.uid
      });
      category.name = newValue;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteCategory(ExpanseCategoryModel category) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection("expanse_categories")
          .doc(category.uid)
          .delete();
      categories.remove(category);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
