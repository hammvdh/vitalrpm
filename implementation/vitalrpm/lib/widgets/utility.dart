import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Utility {
  static error(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      title: 'Error',
      message: message,
      duration: const Duration(seconds: 5),
    ).show(context);
  }

  static warning(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.warning,
        color: Colors.orange,
      ),
      title: 'Warning',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static success(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
      title: 'Success',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
