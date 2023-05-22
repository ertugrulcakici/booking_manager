import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/expanse_category_model.dart';
import 'package:bookingmanager/product/models/expanse_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpansesNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<ExpanseModel> expanses = [];
  List<ExpanseCategoryModel> categories = [];

  ExpansesNotifier();
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
    getExpanses();
  }

  Future<void> getData() async {
    try {
      await getCategories();
      await getExpanses();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> getCategories() async {
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
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> getExpanses() async {
    try {
      isLoading = true;
      expanses.clear();
      final expansesSnapshot = await FirebaseFirestore.instance
          .collection("expanses")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .where("addedTime",
              isGreaterThanOrEqualTo: selectedDate.dayBeginning().timestamp)
          .where("addedTime",
              isLessThanOrEqualTo: selectedDate.dayEnding().timestamp)
          .get();
      expanses = expansesSnapshot.docs
          .map((e) => ExpanseModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteExpanse(ExpanseModel expanse) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection("expanses")
          .doc(expanse.uid)
          .delete();
      expanses.remove(expanse);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
