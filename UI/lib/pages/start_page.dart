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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
            padding: outerPadding,
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
