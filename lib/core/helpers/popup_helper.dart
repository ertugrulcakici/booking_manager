import 'package:bookingmanager/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

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

  Future<void> showOkCancelDialog({
    required String title,
    required String content,
    required VoidCallback onOk,
    required VoidCallback onCancel,
  }) async {
    await showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: onOk,
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
