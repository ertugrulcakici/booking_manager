// ignore_for_file: hash_and_equals

class InvitationModel {
  String code;
  int createdDate;
  int? usedDate;
  String forWhomName;
  String uid;
  String relatedBusinessUid;

  InvitationModel({
    required this.code,
    required this.createdDate,
    this.usedDate,
    required this.forWhomName,
    required this.uid,
    required this.relatedBusinessUid,
  });

  InvitationModel.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        createdDate = json["createdDate"],
        usedDate = json['usedDate'],
        forWhomName = json['forWhomName'],
        uid = json['uid'],
        relatedBusinessUid = json['relatedBusinessUid'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['createdDate'] = createdDate;
    data['usedDate'] = usedDate;
    data['forWhomName'] = forWhomName;
    data['uid'] = uid;
    data['relatedBusinessUid'] = relatedBusinessUid;
    return data;
  }

  @override
  String toString() {
    return 'InvitationModel{code: $code, createdDate: $createdDate, usedDate: $usedDate, forWhomName: $forWhomName, uid: $uid , relatedBusinessUid: $relatedBusinessUid}';
  }

  @override
  operator ==(other) => other is InvitationModel && other.uid == uid;

  bool get isUsed => usedDate != null;
}
