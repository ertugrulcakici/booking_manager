import 'package:bookingmanager/core/helpers/popup_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final Function() onPressed;
  const CustomErrorWidget(
      {super.key, required this.errorMessage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: errorMessage));
                PopupHelper.instance
                    .showSnackBar(message: "Copied to clipboard");
              },
              child: Text(errorMessage)),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text("Try again"),
          )
        ],
      ),
    );
  }
}
