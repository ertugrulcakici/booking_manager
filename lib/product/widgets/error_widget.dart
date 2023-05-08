import 'package:flutter/material.dart';

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
          Text(errorMessage),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text("Try again"),
          )
        ],
      ),
    );
  }
}
