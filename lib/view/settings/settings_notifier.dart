import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsNotifier extends ChangeNotifier {
  String _language =
      EasyLocalization.of(NavigationService.context)!.locale.languageCode;
  String get language => _language;
  set language(String value) {
    _language = value;
    EasyLocalization.of(NavigationService.context)!.setLocale(Locale(value));
    notifyListeners();
  }
}
