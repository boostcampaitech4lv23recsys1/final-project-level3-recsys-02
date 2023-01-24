import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

AppBar mainAppBar(context) {
  return AppBar(
    leading: Container(
        width: 200,
        height: titleHeight,
        color: kWhite,
        child: Image.asset(
          'assets/logo2.png',
        )),
    title: TextField(
      textAlign: TextAlign.center,
      // controller: textcontroller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: '원하시는 노래를 검색하세요',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), borderSide: whiteBorder),
          filled: true,
          contentPadding: const EdgeInsets.all(16),
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search)),
    ),
    actions: [
      ElevatedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: whiteBorder,
            padding: const EdgeInsets.all(16)),
        child: Text('마이페이지', style: subtitleTextStyle),
        onPressed: () {
          Navigator.pushNamed(context, '/mypage');
        },
      ),
      Container(
          height: titleHeight,
          width: buttonWidth,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('로그아웃', style: subtitleTextStyle),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          ))
    ],
  );
}

AppBar mypagenAppBar(context) {
  return AppBar(
    leading: Container(
        width: 200,
        height: titleHeight,
        color: kWhite,
        child: Image.asset(
          'assets/logo2.png',
        )),
    actions: [
      ElevatedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: whiteBorder,
            padding: const EdgeInsets.all(16)),
        child: Text('메인페이지', style: subtitleTextStyle),
        onPressed: () {
          Navigator.pushNamed(context, '/main');
        },
      ),
      Container(
          height: titleHeight,
          width: buttonWidth,
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(16)),
            child: Text('로그아웃', style: subtitleTextStyle),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          ))
    ],
  );
}
