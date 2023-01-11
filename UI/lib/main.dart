import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/signin_page.dart';
import 'package:ui/pages/start_page.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Final Project',
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
