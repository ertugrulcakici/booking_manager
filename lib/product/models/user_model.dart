import 'package:bookingmanager/core/services/cache/cache_service.dart';
import 'package:bookingmanager/product/constants/cache_constants.dart';
import 'package:bookingmanager/product/models/business_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: CacheConstants.userModelTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  late String uid;
  @HiveField(1)
  String relatedBusinessUid = "";
  @HiveField(2)
  late String name;

  // fetched from firebase
  BusinessModel? business;

  UserModel({required this.uid, required this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    relatedBusinessUid = json['relatedBusinessUid'] ?? "";
    name = json['name'];
  }

  updateUserData({
    required String uid,
    required String relatedBusinessUid,
    required String name,
  }) {
    this.uid = uid;
    this.relatedBusinessUid = relatedBusinessUid;
    this.name = name;
    save();
  }

  @override
  Future<void> save() async {
    CacheService.instance.usersBox.put(uid, this);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'relatedBusinessUid': relatedBusinessUid,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, relatedBusinessUid: $relatedBusinessUid, name: $name)';
  }
}
