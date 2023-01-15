import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/pages/login_page.dart';
import 'package:ui/pages/signin/signin_page.dart';
import 'package:ui/pages/start_page.dart';
import 'package:ui/pages/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: kLightGrey, // 강조색
        scaffoldBackgroundColor: kBlack, // 앱 배경색
      ),
      title: 'Final Project',
      home: TestPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text('--- 페이지 목록 ---', style: titleTextStyle))),
                defaultSpacer,
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: kWhite,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('홈페이지',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                defaultSpacer,
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: kWhite,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('로그인페이지',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                defaultSpacer,
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: kWhite,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('회원가입페이지',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SigninPage()));
                  },
                ),
                defaultSpacer,
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: kWhite,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('시작페이지',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StartPage()));
                  },
                ),
                defaultSpacer,
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: kWhite,
                      side: whiteBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('마이페이지',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage()));
                  },
                ),
              ],
            )));
  }
}
