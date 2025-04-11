import 'package:flutter/cupertino.dart';

class ErrorDialogUtility {
  // This method displays a dialog with the error message.
  static void showErrorDialog(BuildContext context, {String errorMessage = "Uh Oh! Looks like an error occurred. Try again."}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
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
