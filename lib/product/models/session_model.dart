import 'package:bookingmanager/product/constants/cache_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'session_model.g.dart';

@HiveType(typeId: CacheConstants.sessionModelTypeId)
class SessionModel extends HiveObject {
  @HiveField(0)
  String addedBy;
  @HiveField(1)
  int personCount;
  @HiveField(2)
  String date;
  @HiveField(3)
  String time;
  @HiveField(4)
  double extra;
  @HiveField(5)
  double discount;
  @HiveField(6)
  String name;
  @HiveField(7)
  String phone;
  @HiveField(8)
  String branchUid;
  @HiveField(9)
  String note;
  @HiveField(10)
  String uid;
  @HiveField(11)
  double subTotal;
  @HiveField(12)
  double total;

  int get timestamp => DateTime(
        int.parse(date.split("/")[0]),
        int.parse(date.split("/")[1]),
        int.parse(date.split("/")[2]),
        int.parse(time.split(":")[0]),
        int.parse(time.split(":")[1]),
      ).millisecondsSinceEpoch;

  SessionModel({
    required this.addedBy,
    required this.personCount,
    required this.date,
    required this.time,
    this.extra = 0,
    this.discount = 0,
    required this.name,
    required this.phone,
    required this.branchUid,
    this.note = "not yok",
    required this.uid,
    this.subTotal = 0,
    this.total = 0,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      addedBy: json['addedBy'],
      personCount: json['personCount'],
      date: json['date'],
      time: json['time'],
      extra: json['extra'] ?? 0,
      discount: json['discount'] ?? 0,
      name: json['name'],
      phone: json['phone'],
      branchUid: json['branchUid'],
      note: json['note'],
      uid: json['uid'],
      subTotal: json['subTotal'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'addedBy': addedBy,
        'personCount': personCount,
        'date': date,
        'time': time,
        'extra': extra,
        'discount': discount,
        'name': name,
        'phone': phone,
        'branchUid': branchUid,
        'note': note,
        'uid': uid,
      };

  @override
  String toString() {
    return 'SessionModel{addedBy: $addedBy, personCount: $personCount, date: $date, time: $time, extra: $extra, discount: $discount, name: $name, phone: $phone, branchUid: $branchUid, note: $note, uid: $uid, subTotal: $subTotal, total: $total}';
  }

  isAllFieldsSame(SessionModel sessionModel) {
    return addedBy == sessionModel.addedBy &&
        personCount == sessionModel.personCount &&
        date == sessionModel.date &&
        time == sessionModel.time &&
        extra == sessionModel.extra &&
        discount == sessionModel.discount &&
        name == sessionModel.name &&
        phone == sessionModel.phone &&
        branchUid == sessionModel.branchUid &&
        note == sessionModel.note;
  }
}
