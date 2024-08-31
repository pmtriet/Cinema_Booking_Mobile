import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeatToastManager {
  static final SeatToastManager _instance = SeatToastManager._internal();

  factory SeatToastManager() {
    return _instance;
  }

  SeatToastManager._internal();

  bool _canShowToast = true;

  set canShowToast(bool value) {
    _canShowToast = value;
  }

  void showToast() {
    if (_canShowToast) {
      _canShowToast = false;

      Fluttertoast.showToast(
        msg: "Cannot chose more than 8 seats",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      ).then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          _canShowToast = true;
        });
      });
    }
  }
}
