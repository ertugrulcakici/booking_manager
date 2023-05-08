import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/view/main/home/home_view.dart';
import 'package:bookingmanager/view/user/account_setup/account_setup_view.dart';
import 'package:flutter/material.dart';

class LoginNotifier extends ChangeNotifier {
  final Map<String, dynamic> formData = {};
  Future<void> login() async {
    if (await AuthService.signIn(
        email: formData["email"], password: formData["password"])) {
      // NavigationService.toPageAndRemoveUntil(const HomeView());
      if (AuthService.instance.user!.relatedBusinessUid.isEmpty) {
        NavigationService.toPageAndRemoveUntil(const AccountSetupView());
      } else {
        NavigationService.toPageAndRemoveUntil(const HomeView());
      }
    }
  }
}
