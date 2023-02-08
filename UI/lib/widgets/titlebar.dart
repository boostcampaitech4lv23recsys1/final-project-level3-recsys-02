import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(String title) {
  String a = title[0].toUpperCase();
  String result = title.substring(1);
  return SizedBox(
      height: titleHeight * 1.2,
      child: Text(a + result, style: titleTextStyle));
}

Widget titleBar2(String title) {
  String a = title[0].toUpperCase();
  String result = title.substring(1);
  return SizedBox(
      height: titleHeight * 1.2,
      child: Text(a + result, style: titleTextStyle4));
}
