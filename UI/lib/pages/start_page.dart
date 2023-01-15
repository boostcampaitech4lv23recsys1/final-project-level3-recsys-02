import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/footer.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              children: [
                startHeader(context),
                defaultSpacer,
                // 서비스 개요
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                        decoration: outerBorder,
                        height: 600,
                        width: _width,
                        child: Center(
                            child: Text('서비스개요', style: titleTextStyle))),
                    defaultSpacer,
                    Container(
                        margin: EdgeInsets.all(30),
                        height: titleHeight * 1.5,
                        width: buttonWidth * 2,
                        decoration: outerBorder,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: kWhite,
                              side: whiteBorder,
                              padding: const EdgeInsets.all(16)),
                          child: Text('시작하기',
                              style: TextStyle(
                                color: kBlack,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                            debugPrint('시작하기');
                          },
                        )),
                  ],
                ),
                const Spacer(),
                footer(),
              ],
            )));
  }
}
