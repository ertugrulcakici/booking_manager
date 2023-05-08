import 'package:bookingmanager/core/services/cache/cache_service.dart';
import 'package:bookingmanager/product/constants/cache_constants.dart';
import 'package:bookingmanager/product/models/invitation_model.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'business_model.g.dart';

@HiveType(typeId: CacheConstants.businessModelTypeId)
class BusinessModel extends HiveObject {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String businessLogoUrl;
  @HiveField(3)
  List<String> workersUidList;
  @HiveField(4)
  List<String> adminsUidList;
  @HiveField(5)
  String ownerUid;
  @HiveField(6)
  List<String> branchesUidList;

  // generated data
  List<UserModel> users = [];

  BusinessModel({
    required this.uid,
    required this.name,
    required this.businessLogoUrl,
    required this.workersUidList,
    required this.adminsUidList,
    required this.ownerUid,
    required this.branchesUidList,
  });

  BusinessModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['businessName'],
        businessLogoUrl = json['businessLogoUrl'],
        workersUidList = json['workersUidList'].cast<String>(),
        adminsUidList = json['adminsUidList'].cast<String>(),
        ownerUid = json['ownerUid'],
        branchesUidList = json['branchesUidList'].cast<String>();

  @override
  Future<void> save() {
    CacheService.instance.businessesBox.put(uid, this);
    return super.save();
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'businessName': name,
        'businessLogoUrl': businessLogoUrl,
        'workersUidList': workersUidList,
        'adminsUidList': adminsUidList,
        'ownerUid': ownerUid,
        'branchesUidList': branchesUidList,
      };

  @override
  String toString() {
    return 'BusinessModel{uid: $uid, name: $name, businessLogoUrl: $businessLogoUrl, workersUidList: $workersUidList, adminsUidList: $adminsUidList, ownerUid: $ownerUid, branchesUidList: $branchesUidList}';
  }

  /// fetch users data
  Future<void> fetchUsers() async {
    try {
      users.clear();
      for (var userUid in workersUidList) {
        DocumentReference? userRef =
            FirebaseFirestore.instance.collection("users").doc(userUid);
        final userData = (await userRef.get()).data();
        UserModel userModel =
            UserModel.fromJson((userData as Map<String, dynamic>));
        users.add(userModel);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// fetch the branches if branches are null
  // Future<void> fetchBranches() async {
  //   try {
  //     branches.clear();
  //     for (var branchUid in branchesUidList) {
  //       DocumentSnapshot branchDoc = await FirebaseFirestore.instance
  //           .collection("branches")
  //           .doc(branchUid)
  //           .get();
  //       if (branchDoc.exists) {
  //         branches.add(
  //             BranchModel.fromJson(branchDoc.data() as Map<String, dynamic>));
  //       }
  //     }
  //   } catch (e) {
  //     throw Exception("Branches couldn't be fetched : $e");
  //   }
  // }
}
