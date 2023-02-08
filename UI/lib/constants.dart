import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin = false;
double boxHeight = 240.0;

BorderRadius kBorder = BorderRadius.circular(12);

Color kLightGrey = const Color(0xFFE5E5E5);
Color kDarkGrey = const Color.fromARGB(255, 155, 155, 155);
Color kkDarkGrey = const Color.fromARGB(255, 155, 155, 155);

Color kBlack = const Color.fromRGBO(11, 11, 11, 1);
Color kBlack2 = const Color.fromRGBO(22, 22, 22, 1);
Color kBlack3 = const Color.fromRGBO(0, 0, 0, 0);
Color kWhite = const Color.fromARGB(255, 240, 240, 240);

const String username = "yongheewon";

EdgeInsets outerMargin = const EdgeInsets.all(20);
EdgeInsets defaultPadding = const EdgeInsets.all(8);
const kPadding = EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8);
const kPadding2 = EdgeInsets.only(top: 2, bottom: 3, left: 4, right: 4);

final hintTextStyle = TextStyle(color: kDarkGrey, fontSize: 13.0);
final defaultTextStyle = TextStyle(color: kWhite, fontSize: 12.0);
final defaultTextStyle2 = TextStyle(color: kkDarkGrey, fontSize: 16.0);
final defaultTextStyle3 = TextStyle(color: kkDarkGrey, fontSize: 14.0);
final defaultTextStyle4 = TextStyle(color: kkDarkGrey, fontSize: 16.0);
final contentsTextStyle = TextStyle(color: kWhite, fontSize: 14.0);
final contentsTextStyle2 = TextStyle(color: kWhite, fontSize: 18.0);
final contentsTextStyle3 = TextStyle(color: kWhite, fontSize: 18.0);
final contentsTextStyle4 = TextStyle(color: kWhite, fontSize: 16.0);
final ccontentsTextStyle = TextStyle(color: kkDarkGrey, fontSize: 17.0);
final subtitleTextStyle = TextStyle(
  color: kWhite,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
final ssubtitleTextStyle = TextStyle(
  color: kWhite,
  fontSize: 20.0,
  //fontWeight: FontWeight,
);
final titleTextStyle = TextStyle(
  color: kWhite,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

final titleTextStyle2 = TextStyle(
  color: kWhite,
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

final titleTextStyle3 = TextStyle(
  color: kkDarkGrey,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

final titleTextStyle4 = TextStyle(
  color: kWhite,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const titleHeight = 45.0;
const buttonWidth = 120.0;

const Widget defaultSpacer = SizedBox(
  width: 20,
  height: 30,
);
const Widget defaultSpacer2 = SizedBox(
  width: 10,
  height: 20,
);

const Widget defaultSpacer3 = SizedBox(
  width: 5,
  height: 10,
);
BorderSide whiteBorder = BorderSide(color: kWhite);

BoxDecoration profileBorder = BoxDecoration(
  border: Border.all(color: Colors.white, width: 1.5),
  shape: BoxShape.circle,
);

BoxDecoration outerBorder = BoxDecoration(
    border: Border.all(color: Colors.white, width: 1.5),
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(8)));
EdgeInsets outerPadding = const EdgeInsets.only(top: 40, left: 160, right: 160);

void enterSession() async {
  final pref = await SharedPreferences.getInstance();
  isLogin = true;
  debugPrint("session == $isLogin");
}

void exitSession() async {
  final pref = await SharedPreferences.getInstance();
  pref.clear();
  isLogin = false;
  debugPrint("session == $isLogin");
}
