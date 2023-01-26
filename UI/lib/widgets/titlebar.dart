import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(String title, {bool isReset = false}) {
  return SizedBox(
      height: titleHeight,
      child: isReset
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: titleTextStyle),
                IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    color: kWhite,
                    onPressed: () {}),
              ],
            )
          : Text(title, style: titleTextStyle));
}
