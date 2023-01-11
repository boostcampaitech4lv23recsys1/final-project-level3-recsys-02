import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/pages/signin_page.dart';

Widget homeHeader(context) {
  var textcontroller = TextEditingController();

  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
          decoration: outerBorder,
          child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Image.asset('../assets/logo.png', height: 50))),
      defaultSpacer,
      Expanded(
          child: Container(
        decoration: outerBorder,
        child: TextField(
          textAlign: TextAlign.center,
          controller: textcontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Hint Text',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: noBorder),
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search)),
        ),
      )),
      defaultSpacer,
      Container(
          height: 45,
          decoration: outerBorder,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kLightGrey,
                side: noBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('마이페이지',
                style: TextStyle(fontSize: defaultFontSize, color: kDarkGrey)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SigninPage()));
              debugPrint('마이페이지');
            },
          ))
    ],
  );
}
