import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_view.dart';
import 'package:flutter/material.dart';

class RegisterNotifier extends ChangeNotifier {
  final Map<String, dynamic> formData = {};

  Future<void> register() async {
    bool success = await AuthService.register(
        email: formData["email"],
        password: formData["password"],
        name: formData["name"]);

    if (success) {
      NavigationService.toPageAndRemoveUntil(const AccountSetupView());
    }
  }
}
