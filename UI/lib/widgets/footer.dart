import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget footer() {
  return Container(
      decoration: outerBorder,
      height: buttonHeight,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text('김동영',
            style: TextStyle(color: kDarkGrey, fontSize: contentsFontSize)),
        Text('민복기',
            style: TextStyle(color: kDarkGrey, fontSize: contentsFontSize)),
        Text('박경준',
            style: TextStyle(color: kDarkGrey, fontSize: contentsFontSize)),
        Text('오희정',
            style: TextStyle(color: kDarkGrey, fontSize: contentsFontSize)),
        Text('용희원',
            style: TextStyle(color: kDarkGrey, fontSize: contentsFontSize)),
      ]));
}
