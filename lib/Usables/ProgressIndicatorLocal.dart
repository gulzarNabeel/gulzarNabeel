import 'dart:async';

import 'package:diabetes/Usables/CustomTextField.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorLocal {

  static ProgressIndicatorLocal? _instance;
  ProgressIndicatorLocal._();
  bool isOpen = false;

  factory ProgressIndicatorLocal() {
    if (_instance == null) {
      _instance = ProgressIndicatorLocal._();
    }
    return _instance!;
  }

  showAlert(BuildContext context) {
    if(isOpen == false) {
      isOpen = true;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          }
      );
      Timer.periodic(const Duration(seconds: 30), (timer) async {
        timer.cancel();
        if (isOpen == true) {
          isOpen = false;
          print(false.toString());
          Navigator.of(context).pop();
        }
      });
    }
  }

  hideAlert(BuildContext context) {
    if(isOpen == true) {
      isOpen = false;
      print(false.toString());
      Navigator.pop(context);
    }
  }
}