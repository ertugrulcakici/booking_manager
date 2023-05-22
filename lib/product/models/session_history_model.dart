import 'package:bookingmanager/product/enums/session_history_type_enum.dart';
import 'package:bookingmanager/product/models/session_model.dart';

class SessionHistoryModel {
  int timestamp;
  String? _uid;
  set uid(String value) => _uid = value;
  String get uid => _uid ?? timestamp.toString();
  SessionModel originalSession;
  SessionModel? updatedSession;
  SessionHistoryType historyType;
  String relatedBusinessUid;
  String by;

  SessionHistoryModel({
    required this.timestamp,
    required this.originalSession,
    this.updatedSession,
    String? uid,
    required this.historyType,
    required this.relatedBusinessUid,
    required this.by,
  }) {
    _uid = uid;
  }

  factory SessionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryModel(
      timestamp: json['timestamp'],
      uid: json['uid'],
      originalSession: SessionModel.fromJson(json['originalSession']),
      updatedSession: json['updatedSession'] == null
          ? null
          : SessionModel.fromJson(json['updatedSession']),
      historyType: SessionHistoryType.values
          .firstWhere((element) => element.toString() == json['historyType']),
      relatedBusinessUid: json['relatedBusinessUid'],
      by: json['by'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['uid'] = uid;
    data['originalSession'] = originalSession.toJson();
    data['updatedSession'] = updatedSession?.toJson();
    data['historyType'] = historyType.toString();
    data['relatedBusinessUid'] = relatedBusinessUid;
    data['by'] = by;
    return data;
  }

  @override
  String toString() {
    return 'SessionHistoryModel{timestamp: $timestamp, uid: $uid, originalSession: $originalSession, updatedSession: $updatedSession, historyType: $historyType, relatedBusinessUid: $relatedBusinessUid, by: $by}';
  }
}
