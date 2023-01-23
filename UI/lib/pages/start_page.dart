import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/login_page.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/footer.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  var name;

  void navigationPage() {
    name == ''
        ? {Navigator.pushNamed(context, '/main')}
        : Navigator.pushNamed(context, '/main');
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget startHeader() {
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
                    'assets/logo2.png',
                  ))),
          const Spacer(),
          isLogin
              ? Row(children: [
                  Container(
                      height: titleHeight,
                      width: buttonWidth,
                      decoration: outerBorder,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: whiteBorder,
                            padding: const EdgeInsets.all(16)),
                        child: Text('메인페이지', style: subtitleTextStyle),
                        onPressed: () {
                          Navigator.pushNamed(context, '/main');
                        },
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
                        child: Text('로그아웃', style: subtitleTextStyle),
                        onPressed: () {
                          setSession(false);
                          setState(() {});
                          Navigator.popUntil(
                              context, ModalRoute.withName('/home'));
                        },
                      ))
                ])
              : Row(
                  children: [
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
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => LoginPage(),
                              ),
                            );
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
                ),
        ],
      );
    }

    return Scaffold(
        body: Padding(
            padding: outerPadding,
            child: Column(
              children: [
                startHeader(), defaultSpacer,
                // 서비스 개요
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                        decoration: outerBorder,
                        height: 600,
                        width: width,
                        child: Center(
                            child: Text('서비스개요', style: titleTextStyle))),
                  ],
                ),
                const Spacer(),
                footer(),
              ],
            )));
  }
}
