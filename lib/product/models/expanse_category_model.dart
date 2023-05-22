// ignore_for_file: hash_and_equals

class ExpanseCategoryModel {
  String uid;
  String name;
  String relatedBusinessUid;
  int addedTime;
  String addedBy;
  int lastUpdatedTime;
  String lastUpdatedBy;

  ExpanseCategoryModel({
    required this.uid,
    required this.name,
    required this.relatedBusinessUid,
    required this.addedTime,
    required this.addedBy,
    required this.lastUpdatedTime,
    required this.lastUpdatedBy,
  });

  factory ExpanseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpanseCategoryModel(
      uid: json['uid'],
      name: json['name'],
      relatedBusinessUid: json['relatedBusinessUid'],
      addedTime: json['addedTime'],
      addedBy: json['addedBy'],
      lastUpdatedTime: json['lastUpdatedTime'],
      lastUpdatedBy: json['lastUpdatedBy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'relatedBusinessUid': relatedBusinessUid,
        'addedTime': addedTime,
        'addedBy': addedBy,
        'lastUpdatedTime': lastUpdatedTime,
        'lastUpdatedBy': lastUpdatedBy,
      };

  @override
  String toString() {
    return 'ExpanseCategoryModel{uid: $uid, name: $name, relatedBusinessUid: $relatedBusinessUid, addedTime: $addedTime, addedBy: $addedBy, lastUpdatedTime: $lastUpdatedTime, lastUpdatedBy: $lastUpdatedBy}';
  }

  @override
  operator ==(other) => other is ExpanseCategoryModel && other.uid == uid;
}
