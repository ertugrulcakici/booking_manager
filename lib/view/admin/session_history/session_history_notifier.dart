import 'dart:developer';

import 'package:bookingmanager/core/extensions/datetime_extensions.dart';
import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/session_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SessionLogsNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<SessionHistoryModel> sessionHistories = [];
  SessionLogsNotifier();

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
    getLogs();
  }

  Future<void> getLogs() async {
    try {
      isLoading = true;
      sessionHistories.clear();
      log(selectedDate.toString());
      final logsDocs = await FirebaseFirestore.instance
          .collection("session_history")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .where("timestamp",
              isGreaterThanOrEqualTo: selectedDate.dayBeginning().timestamp)
          .where("timestamp",
              isLessThanOrEqualTo: selectedDate.dayEnding().timestamp)
          .get();

      sessionHistories = logsDocs.docs
          .map((e) => SessionHistoryModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
