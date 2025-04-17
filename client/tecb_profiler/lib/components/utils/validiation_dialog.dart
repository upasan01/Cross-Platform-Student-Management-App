import 'package:flutter/cupertino.dart';

class ValidationDialog {
  static void show({
    required BuildContext context,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Missing Required Fields"),
        content: const Text("Please fill all the required fields."),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
