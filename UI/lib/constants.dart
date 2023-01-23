import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;
double boxHeight = 250.0;

BorderRadius kBorder = BorderRadius.circular(12);

Color kLightGrey = const Color(0xFFE5E5E5);
Color kDarkGrey = const Color.fromARGB(255, 155, 155, 155);

Color kBlack = const Color.fromRGBO(22, 22, 22, 1);
Color kWhite = const Color.fromARGB(255, 240, 240, 240);

EdgeInsets outerMargin = const EdgeInsets.all(20);
EdgeInsets defaultPadding = const EdgeInsets.all(8);
const kPadding = EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8);

final hintTextStyle = TextStyle(color: kDarkGrey, fontSize: 13.0);
final defaultTextStyle = TextStyle(color: kWhite, fontSize: 12.0);
final contentsTextStyle = TextStyle(color: kWhite, fontSize: 14.0);
final subtitleTextStyle = TextStyle(
  color: kWhite,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);
final titleTextStyle = TextStyle(
  color: kWhite,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const titleHeight = 45.0;
const buttonWidth = 120.0;

const Widget defaultSpacer = SizedBox(
  width: 20,
  height: 20,
);
BorderSide whiteBorder =
    BorderSide(color: kWhite, strokeAlign: StrokeAlign.outside);

BoxDecoration profileBorder = BoxDecoration(
  border: Border.all(color: Colors.white, width: 1.5),
  shape: BoxShape.circle,
);

BoxDecoration outerBorder = BoxDecoration(
    border: Border.all(color: Colors.white, width: 1.5),
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(8)));
EdgeInsets outerPadding = const EdgeInsets.only(top: 40, left: 80, right: 80);

void getSession() async {
  final pref = await SharedPreferences.getInstance();
  isLogin = pref.getBool('isLogin')!;
  debugPrint("session == $isLogin");
}

void setSession(val) async {
  final pref = await SharedPreferences.getInstance();
  pref.setBool('isLogin', val);
  isLogin = val;
  debugPrint("session == $isLogin");
}
