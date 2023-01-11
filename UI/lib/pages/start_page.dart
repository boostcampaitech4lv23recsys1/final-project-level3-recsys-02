import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/signin_header.dart';
import 'package:ui/widgets/start_header.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return SafeArea(
        minimum: const EdgeInsets.all(60),
        child: Scaffold(
            body: Column(
          children: [
            startHeader(context),
            defaultSpacer,
            // 서비스 개요
            Container(
                decoration: outerBorder,
                height: 500,
                width: _width,
                child: const Expanded(child: Center(child: Text('서비스개요')))),
            defaultSpacer,
            Container(
                decoration: outerBorder,
                // BoxConstraints has non-normalized width constraints.
                // The offending constraints were:
                //   BoxConstraints(64.0<=w<=45.0, 36.0<=h<=80.0; NOT NORMALIZED)
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(_width * 0.2, buttonHeight),
                      backgroundColor: kLightGrey,
                      side: noBorder,
                      padding: const EdgeInsets.all(16)),
                  child: Text('시작하기',
                      style: TextStyle(
                          fontSize: defaultFontSize, color: kDarkGrey)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                    debugPrint('시작하기');
                  },
                )),
            const Spacer(),
            footer(),
          ],
        )));
  }
}
