import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget customHeader(context, bool isMain) {
  var textcontroller = TextEditingController();
  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
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
            hintText: '원하시는 노래를 검색하세요',
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
          child: isMain
              ? ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('마이페이지', style: subtitleTextStyle),
                  onPressed: () {
                    Navigator.pushNamed(context, '/mypage');
                  },
                )
              : ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('메인페이지', style: subtitleTextStyle),
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                )),
    ],
  );
}

Widget startHeader(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, '/main');
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
              Navigator.pushNamed(context, '/login');
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
              Navigator.pushNamed(context, '/signin');
            },
          ))
    ],
  );
}
