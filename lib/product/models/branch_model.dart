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
  // @HiveField(3)
  // String priceUnitType;
  @HiveField(3)
  num unitPrice;
  // @HiveField(5)
  // List<BranchProperty> branchProperties;
  // elements will be <Map<String, String>>
  @HiveField(4)
  List<String> workingHoursList;

  BranchModel({
    required this.uid,
    required this.relatedBusinessUid,
    required this.name,
    // required this.priceUnitType,
    required this.unitPrice,
    required this.workingHoursList,
    // required this.branchProperties,
  });

  BranchModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        relatedBusinessUid = json['relatedBusinessUid'],
        name = json['name'],
        // priceUnitType = json['priceUnitType'],
        unitPrice = json['unitPrice'],
        workingHoursList = json['workingHoursList'].cast<String>()

  // branchProperties = json['branchProperties']
  //     .map<BranchProperty>((e) {
  //       return BranchProperty.fromJson(e);
  //     })
  //     .toList()
  //     .cast<BranchProperty>()
  ;

  reBuildFromCopy(BranchModel branchModel) {
    uid = branchModel.uid;
    relatedBusinessUid = branchModel.relatedBusinessUid;
    name = branchModel.name;
    // priceUnitType = branchModel.priceUnitType;
    unitPrice = branchModel.unitPrice;
    workingHoursList = branchModel.workingHoursList;
    // branchProperties = branchModel.branchProperties;
  }

  BranchModel copyWith({
    String? uid,
    String? relatedBusinessUid,
    String? name,
    String? priceUnitType,
    num? unitPrice,
    List<String>? workingHoursList,
    // List<BranchProperty>? branchProperties,
  }) {
    return BranchModel(
      uid: uid ?? this.uid,
      relatedBusinessUid: relatedBusinessUid ?? this.relatedBusinessUid,
      name: name ?? this.name,
      // priceUnitType: priceUnitType ?? this.priceUnitType,
      unitPrice: unitPrice ?? this.unitPrice,
      workingHoursList: workingHoursList ?? this.workingHoursList,
      // branchProperties: branchProperties ?? this.branchProperties,
    );
  }

  @override
  String toString() {
    // return 'BranchModel(uid: $uid, relatedBusinessUid: $relatedBusinessUid, name: $name, priceUnitType: $priceUnitType, unitPrice: $unitPrice, workingHoursList: $workingHoursList, branchProperties: $branchProperties)';
    // return 'BranchModel(uid: $uid, relatedBusinessUid: $relatedBusinessUid, name: $name, priceUnitType: $priceUnitType, unitPrice: $unitPrice, workingHoursList: $workingHoursList)';
    return 'BranchModel(uid: $uid, relatedBusinessUid: $relatedBusinessUid, name: $name, unitPrice: $unitPrice, workingHoursList: $workingHoursList)';
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "relatedBusinessUid": relatedBusinessUid,
        "name": name,
        // "priceUnitType": priceUnitType,
        "unitPrice": unitPrice,
        "workingHoursList": workingHoursList,
        // "branchProperties": branchProperties.map((e) => e.toJson()).toList(),
      };
}
