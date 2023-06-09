import 'dart:async';

import 'package:bookingmanager/core/services/auth/auth_service.dart';
import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:bookingmanager/product/constants/app_constants.dart';
import 'package:bookingmanager/view/auth/login/login_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 120.0,
            ),
            const SizedBox(height: 24.0),
            Text(
              LocaleKeys.app_name.tr(),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              LocaleKeys.splash_version.tr(args: [
                "${AppConstants.appVersionName}+${AppConstants.appVersionCode}"
              ]),
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24.0),
            CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    if (await AuthService.instance.isLoggedIn) {
      await AuthService.init();
    } else {
      NavigationService.toPageAndRemoveUntil(const LoginView());
    }
  }
}
