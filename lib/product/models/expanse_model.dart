// ignore_for_file: hash_and_equals

class ExpanseModel {
  String addedBy;
  int addedTime;
  double amount;
  int lastUpdatedTime;
  String lastUpdatedBy;
  String uid;
  String categoryUid;
  String note;
  String relatedBusinessUid;

  ExpanseModel({
    required this.addedBy,
    required this.addedTime,
    required this.amount,
    required this.lastUpdatedTime,
    required this.lastUpdatedBy,
    required this.uid,
    required this.categoryUid,
    required this.note,
    required this.relatedBusinessUid,
  });

  factory ExpanseModel.fromJson(Map<String, dynamic> json) {
    return ExpanseModel(
      addedBy: json['addedBy'],
      addedTime: json['addedTime'],
      amount: json['amount'],
      lastUpdatedTime: json['lastUpdatedTime'],
      lastUpdatedBy: json['lastUpdatedBy'],
      uid: json['uid'],
      categoryUid: json['categoryUid'],
      note: json['note'],
      relatedBusinessUid: json['relatedBusinessUid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'addedBy': addedBy,
        'addedTime': addedTime,
        'amount': amount,
        'lastUpdatedTime': lastUpdatedTime,
        'lastUpdatedBy': lastUpdatedBy,
        'uid': uid,
        'categoryUid': categoryUid,
        'note': note,
        'relatedBusinessUid': relatedBusinessUid,
      };

  @override
  String toString() => toJson().toString();

  @override
  operator ==(other) => other is ExpanseModel && other.uid == uid;
}
