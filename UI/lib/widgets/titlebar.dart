import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(double w, String title, {bool isReset = false}) {
  return SizedBox(
    width: w,
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
        : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(title, style: titleTextStyle),
            const Spacer(),
          ]),
  );
}
