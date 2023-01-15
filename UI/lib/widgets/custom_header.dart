import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/main.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/pages/login_page.dart';
import 'package:ui/pages/signin/prefer_input.dart';
import 'package:ui/pages/user_page.dart';

Widget customHeader(context, String type) {
  var textcontroller = TextEditingController();
  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Container(
              width: 180,
              height: titleHeight,
              color: kWhite,
              child: Image.asset(
                'logo2.png',
              ))),
      defaultSpacer,
      Expanded(
          child: TextField(
        textAlign: TextAlign.center,
        controller: textcontroller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: '검색',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: whiteBorder),
            filled: true,
            contentPadding: const EdgeInsets.all(16),
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search)),
      )),
      defaultSpacer,
      Container(
          height: titleHeight,
          width: buttonWidth,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text(type, style: subtitleTextStyle),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TestPage()));
            },
          ))
    ],
  );
}

Widget startHeader(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Container(
              width: 180,
              height: titleHeight,
              color: kWhite,
              child: Image.asset(
                'logo2.png',
              ))),
      const Spacer(),
      Container(
          height: titleHeight,
          width: buttonWidth,
          decoration: outerBorder,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('로그인', style: subtitleTextStyle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )),
      defaultSpacer,
      Container(
          height: titleHeight,
          width: buttonWidth,
          decoration: outerBorder,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('회원가입', style: subtitleTextStyle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrefernceInput()));
            },
          ))
    ],
  );
}
