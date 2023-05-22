import 'dart:async';

import 'package:bookingmanager/core/services/localization/locale_keys.g.dart';
import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// This class is used to show popups.
/// Within instances of this class, you can call the methods for showing popups.
/// You can use this class as a singleton.
/// Via static methods, you can reconfigure the instance.
class PopupHelper {
  PopupHelper._();
  static final PopupHelper _instance = PopupHelper._();
  static PopupHelper get instance => _instance;

  static BuildContext get _context =>
      NavigationService.navigatorKey.currentContext!;

  Future<void> showSnackBar({
    required String message,
    bool error = false,
    Duration duration = const Duration(seconds: 3),
  }) async {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: error
            ? Colors.red
            : Theme.of(_context).snackBarTheme.backgroundColor,
      ),
    );
  }

  Future<void> showToastMessage(
      {required String message, bool error = false, bool long = false}) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: error
            ? Colors.red
            : Theme.of(_context).snackBarTheme.backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> showOkCancelDialog({
    required String title,
    required String content,
    required Function() onOk,
    Function()? onCancel,
  }) async {
    await showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              NavigationService.back();
            },
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              onOk();
              NavigationService.back();
            },
            child: Text(LocaleKeys.ok.tr()),
          ),
        ],
      ),
    );
  }
}
