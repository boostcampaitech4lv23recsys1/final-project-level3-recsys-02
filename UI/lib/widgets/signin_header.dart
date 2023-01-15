import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/signin/prefer_input.dart';
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
          height: titleHeight,
          width: buttonWidth,
          decoration: outerBorder,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('가입하기', style: subtitleTextStyle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrefernceInput()));
              debugPrint('가입하기');
            },
          ))
    ],
  );
}
