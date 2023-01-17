import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(double w, String title, {bool withReset = true, Function()?}) {
  return SizedBox(
    width: w,
    height: titleHeight,
    child: withReset
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: titleTextStyle),
              IconButton(
                  icon: const Icon(Icons.autorenew_rounded),
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
