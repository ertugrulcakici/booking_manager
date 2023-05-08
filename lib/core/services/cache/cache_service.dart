import 'package:bookingmanager/product/models/business_model.dart';
import 'package:bookingmanager/product/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static bool _inited = false;
  CacheService._();
  static final CacheService _instance = CacheService._();
  static CacheService get instance =>
      _inited ? _instance : throw Exception("CacheService not inited");

  late final Box<dynamic> appSettingsBox;
  late final Box<UserModel> usersBox;
  late final Box<BusinessModel> businessesBox;

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;

    await Hive.initFlutter();
    // Hive adaptor registrations
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(BusinessModelAdapter());

    // Box initializations
    if (!Hive.isBoxOpen("appSettings")) {
      CacheService.instance.appSettingsBox = await Hive.openBox("appSettings");
    } else {
      CacheService.instance.appSettingsBox = Hive.box("appSettings");
    }

    if (!Hive.isBoxOpen("users")) {
      CacheService.instance.usersBox = await Hive.openBox("users");
    } else {
      CacheService.instance.usersBox = Hive.box("users");
    }

    if (!Hive.isBoxOpen("businesses")) {
      CacheService.instance.businessesBox = await Hive.openBox("businesses");
    } else {
      CacheService.instance.businessesBox = Hive.box("businesses");
    }
  }
}
