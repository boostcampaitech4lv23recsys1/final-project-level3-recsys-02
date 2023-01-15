import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget titleBar(double w, String title, {bool withArrow = true}) {
  return SizedBox(
    width: w,
    height: titleHeight,
    child: withArrow
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: titleTextStyle),
              const Spacer(),
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: kWhite,
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  color: kWhite,
                  onPressed: () {}),
            ],
          )
        : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            defaultSpacer,
            Text(title, style: titleTextStyle),
            const Spacer(),
          ]),
  );
}
