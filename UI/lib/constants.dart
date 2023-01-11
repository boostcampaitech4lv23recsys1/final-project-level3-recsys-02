import 'package:flutter/material.dart';
import 'package:ui/models/item.dart';

Color kLightGrey = const Color(0xFFE5E5E5);
Color kDarkGrey = const Color.fromARGB(255, 155, 155, 155);

const kPadding = EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8);
const kBorderRadius = 8.0;

const contentsFontSize = 16.0;
const defaultFontSize = 18.0;
const titleFontSize = 20.0;

const buttonHeight = 45.0;

const Widget defaultSpacer = SizedBox(
  width: 20,
  height: 20,
);
BorderSide noBorder = const BorderSide(
  width: 0,
  style: BorderStyle.none,
);
BoxDecoration outerBorder =
    BoxDecoration(border: Border.all(color: Colors.red));

EdgeInsets outerMargin = const EdgeInsets.all(20);
EdgeInsets defaultPadding = const EdgeInsets.all(8);

List<Item> itemList = [
  Item(track: 0, trackName: '가', artist: 0, artistName: 'artistName'),
  Item(track: 1, trackName: '나', artist: 0, artistName: 'artistName'),
  Item(track: 2, trackName: '다', artist: 0, artistName: 'artistName'),
  Item(track: 3, trackName: '라', artist: 0, artistName: 'artistName'),
  Item(track: 4, trackName: '마', artist: 0, artistName: 'artistName'),
  Item(track: 5, trackName: '바', artist: 0, artistName: 'artistName'),
  Item(track: 6, trackName: '사', artist: 0, artistName: 'artistName'),
  Item(track: 7, trackName: '아', artist: 0, artistName: 'artistName'),
  Item(track: 8, trackName: '자', artist: 0, artistName: 'artistName'),
  Item(track: 9, trackName: '차', artist: 0, artistName: 'artistName'),
];
