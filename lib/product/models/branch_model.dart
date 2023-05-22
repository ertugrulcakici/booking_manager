import 'package:bookingmanager/product/constants/cache_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'branch_model.g.dart';

@HiveType(typeId: CacheConstants.businessModelTypeId)
class BranchModel extends HiveObject {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String relatedBusinessUid;
  @HiveField(2)
  String name;
  @HiveField(3)
  num unitPrice;
  @HiveField(4)
  List<String> workingHoursList;

  BranchModel({
    required this.uid,
    required this.relatedBusinessUid,
    required this.name,
    required this.unitPrice,
    required this.workingHoursList,
  });

  BranchModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        relatedBusinessUid = json['relatedBusinessUid'],
        name = json['name'],
        unitPrice = json['unitPrice'],
        workingHoursList = json['workingHoursList'].cast<String>();

  reBuildFromCopy(BranchModel branchModel) {
    uid = branchModel.uid;
    relatedBusinessUid = branchModel.relatedBusinessUid;
    name = branchModel.name;
    unitPrice = branchModel.unitPrice;
    workingHoursList = branchModel.workingHoursList;
  }

  BranchModel copyWith({
    String? uid,
    String? relatedBusinessUid,
    String? name,
    String? priceUnitType,
    num? unitPrice,
    List<String>? workingHoursList,
  }) {
    return BranchModel(
      uid: uid ?? this.uid,
      relatedBusinessUid: relatedBusinessUid ?? this.relatedBusinessUid,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      workingHoursList: workingHoursList ?? this.workingHoursList,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "relatedBusinessUid": relatedBusinessUid,
        "name": name,
        "unitPrice": unitPrice,
        "workingHoursList": workingHoursList,
      };
}
