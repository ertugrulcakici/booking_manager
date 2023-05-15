// ignore_for_file: hash_and_equals

class ExpanseModel {
  String uid;
  String categoryUid;
  double amount;
  String note;
  String relatedBusinessUid;
  int addedTime;
  int lastUpdatedTime;

  ExpanseModel({
    required this.uid,
    required this.categoryUid,
    required this.amount,
    required this.note,
    required this.relatedBusinessUid,
    required this.addedTime,
    required this.lastUpdatedTime,
  });

  factory ExpanseModel.fromJson(Map<String, dynamic> json) {
    return ExpanseModel(
      uid: json['uid'],
      categoryUid: json['categoryUid'],
      amount: json['amount'],
      note: json['note'],
      relatedBusinessUid: json['relatedBusinessUid'],
      addedTime: json['addedTime'],
      lastUpdatedTime: json['lastUpdatedTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'categoryUid': categoryUid,
        'amount': amount,
        'note': note,
        'relatedBusinessUid': relatedBusinessUid,
        'addedTime': addedTime,
        'lastUpdatedTime': lastUpdatedTime,
      };

  @override
  String toString() {
    return 'ExpanseModel{uid: $uid, categoryUid: $categoryUid, amount: $amount, note: $note, relatedBusinessUid: $relatedBusinessUid, addedTime: $addedTime, lastUpdatedTime: $lastUpdatedTime}';
  }

  @override
  operator ==(other) => other is ExpanseModel && other.uid == uid;
}
