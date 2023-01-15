import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget footer() {
  return SizedBox(
      height: titleHeight,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text('김동영', style: TextStyle(color: kLightGrey, fontSize: 12.0)),
        Text('민복기', style: TextStyle(color: kLightGrey, fontSize: 12.0)),
        Text('박경준', style: TextStyle(color: kLightGrey, fontSize: 12.0)),
        Text('오희정', style: TextStyle(color: kLightGrey, fontSize: 12.0)),
        Text('용희원', style: TextStyle(color: kLightGrey, fontSize: 12.0)),
      ]));
}
