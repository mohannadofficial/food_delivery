import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String text,
  required selectedColor state,
}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: getSelectedColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum selectedColor {
  SUCSESS,
  ERROR,
  WARNING,
}

Color getSelectedColor(selectedColor state) {
  Color color;
  switch (state) {
    case selectedColor.SUCSESS:
      color = Colors.green;
      break;
    case selectedColor.ERROR:
      color = Colors.red;
      break;
    case selectedColor.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}