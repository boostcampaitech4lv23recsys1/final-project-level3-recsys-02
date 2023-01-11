import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/start_page.dart';

Widget signinHeader(context) {
  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
          decoration: outerBorder,
          child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StartPage()));
              },
              child: Image.asset('../assets/logo.png', height: 50))),
      Spacer(),
      Container(
          height: buttonHeight,
          decoration: outerBorder,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kLightGrey,
                side: noBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('가입하기',
                style: TextStyle(fontSize: defaultFontSize, color: kDarkGrey)),
            onPressed: () {
              debugPrint('가입하기');
            },
          ))
    ],
  );
}
