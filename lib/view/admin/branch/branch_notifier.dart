import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/models/branch_model.dart';
import 'package:flutter/foundation.dart';

class BranchNotifier extends ChangeNotifier {
  Map<String, dynamic> formData = {
    "uid": "",
    "relatedBusinessUid": "",
    "name": "",
    "priceUnitType": "person",
    "unitPrice": 0,
    "workingHoursList": [],
    "branchProperties": []
  };
  BranchModel? branch;

  bool _priceForPerson = true;
  bool get priceForPerson => _priceForPerson;
  set priceForPerson(bool value) {
    _priceForPerson = value;
    if (value) {
      formData["priceUnitType"] = "person";
    } else {
      formData["priceUnitType"] = "hour";
    }

    notifyListeners();
  }

  BranchNotifier([this.branch]) {
    if (branch != null) {
      formData = branch!.toJson();
      // formData["uid"] = branch!.uid;
      // formData["relatedBusinessUid"] = branch!.relatedBusinessUid;
      // formData["name"] = branch!.name;
      // formData["unitPrice"] = branch!.unitPrice;
      // formData["workingHoursList"] = branch!.workingHoursList;
      // formData["priceUnitType"] = branch!.priceUnitType;
      // if (branch!.priceUnitType == "person") {
      //   _priceForPerson = true;
      // } else {
      //   _priceForPerson = false;
      // }
      // formData["branchProperties"] = branch!.branchProperties;
    }
  }

  Future<void> save() async {
    if (branch == null) {
      formData["uid"] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    formData["relatedBusinessUid"] =
        AuthService.instance.user!.relatedBusinessUid;

    NavigationService.back(data: BranchModel.fromJson(formData));
  }
}
