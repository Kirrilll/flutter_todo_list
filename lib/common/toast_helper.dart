import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastHelper {
  static showToast(
      {required BuildContext context,
      required String label,
      bool isError = false}) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(_createToast(label: label, isError: isError));
  }

  static _createToast({required String label, bool isError = false}) => SnackBar(
    content: Text(label),
    backgroundColor: isError
        ? Colors.deepOrange
        : Colors.green,
    duration: const Duration(seconds: 2),
  );
}
