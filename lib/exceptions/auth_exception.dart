import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthException implements Exception {
  String message;
  AuthException(String message) {
    this.message = message;
  }

  String toString() {
    return this.message;
  }

  // void navigate() {
  //   Fluttertoast.showToast(msg: message);
  //   // Navigator.of(context).pushAndRemoveUntil(
  //   //     MaterialPageRoute(builder: (_) => AppSplashWidget()),
  //   //     (Route<dynamic> route) => false);
  // }
}
