import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/product/mixins/loading_notifier_mixin.dart';
import 'package:bookingmanager/product/models/session_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SessionLogsNotifier extends ChangeNotifier with LoadingNotifierMixin {
  List<SessionHistoryModel> logs = [];
  SessionLogsNotifier();

  Future<void> getLogs() async {
    try {
      isLoading = true;
      logs.clear();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final logsDocs = await FirebaseFirestore.instance
          .collection("session_history")
          .where("relatedBusinessUid",
              isEqualTo: AuthService.instance.user!.relatedBusinessUid)
          .where("timestamp", isGreaterThanOrEqualTo: today)
          .where("timestamp",
              isLessThanOrEqualTo: today.add(const Duration(days: 1)))
          .get();

      logs = logsDocs.docs
          .map((e) => SessionHistoryModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
