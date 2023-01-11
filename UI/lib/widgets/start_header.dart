import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/signin_page.dart';

Widget startHeader(context) {
  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
          decoration: outerBorder,
          child: Image.asset('../assets/logo.png', height: 50)),
      Spacer(),
      Container(
          height: buttonHeight,
          decoration: outerBorder,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kLightGrey,
                side: noBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('로그인',
                style: TextStyle(fontSize: defaultFontSize, color: kDarkGrey)),
            onPressed: () {
              debugPrint('로그인');
            },
          )),
      defaultSpacer,
      Container(
          height: buttonHeight,
          decoration: outerBorder,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kLightGrey,
                side: noBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('회원가입',
                style: TextStyle(fontSize: defaultFontSize, color: kDarkGrey)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SigninPage()));
              debugPrint('회원가입');
            },
          ))
    ],
  );
}
