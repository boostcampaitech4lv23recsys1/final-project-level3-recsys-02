import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/utils/dio_client.dart';

AppBar mainAppBar(context) {
  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    backgroundColor: kBlack,
    leading: ElevatedButton(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(12)),
      child: Image.asset(
        'assets/logo.png',
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/main');
      },
    ),
    leadingWidth: 200,
    title: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: TextField(
          textAlign: TextAlign.center,
          // controller: textcontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: '원하시는 노래를 검색하세요',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: whiteBorder),
              filled: true,
              contentPadding: const EdgeInsets.all(12),
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search)),
        )),
    titleSpacing: 20,
    actions: [
      Container(
        width: buttonWidth,
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.only(right: 10),
        child: ElevatedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: whiteBorder,
              padding: const EdgeInsets.all(12)),
          child: Text('마이페이지', style: subtitleTextStyle),
          onPressed: () {
            // list<str> = likesList;
            // userInfo = profile;

            Navigator.pushNamed(context, '/mypage');
          },
        ),
      ),
      Container(
          width: buttonWidth,
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.only(right: 20),
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(12)),
            child: Text('로그아웃', style: subtitleTextStyle),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          )),
    ],
  );
}

AppBar mypagenAppBar(context) {
  return AppBar(
    toolbarHeight: 80,
    elevation: 0,
    backgroundColor: kBlack,
    leading: ElevatedButton(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(12)),
      child: Image.asset(
        'assets/logo.png',
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/main');
      },
    ),
    leadingWidth: 200,
    actions: [
      Container(
          width: buttonWidth,
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.only(right: 20),
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(12)),
            child: Text('로그아웃', style: subtitleTextStyle),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          )),
    ],
  );
}
