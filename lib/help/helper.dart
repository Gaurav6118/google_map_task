import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// This class is using for toast messaging and any method call whole app
class Helper {
  DateTime? currentBackPressTime;

  static void showToast(dynamic message) {
    Fluttertoast.showToast(
        textColor: Colors.white,
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void showLongToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }
}
