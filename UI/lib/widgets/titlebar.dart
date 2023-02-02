import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(String title) {
  return SizedBox(
      height: titleHeight, child: Text(title, style: titleTextStyle));
}
