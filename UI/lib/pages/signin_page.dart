import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/sample_card.dart';
import 'package:ui/widgets/signin_header.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  Widget divider(String title, String explain) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: titleFontSize)),
        defaultSpacer,
        Text(explain, style: TextStyle(fontSize: defaultFontSize))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return SafeArea(
        minimum: const EdgeInsets.all(60),
        child: Scaffold(
            body: Column(children: [
          signinHeader(context),
          defaultSpacer,
          Container(
            decoration: outerBorder,
            height: 700,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 개인정보
                  Container(
                      padding: defaultPadding,
                      height: 300,
                      alignment: Alignment.topLeft,
                      width: _width,
                      decoration: outerBorder,
                      child: Column(
                          children: [divider('STEP 0', '개인정보를 입력해주세요')])),
                  // 장르
                  Container(
                      padding: defaultPadding,
                      alignment: Alignment.topLeft,
                      width: _width,
                      height: 250,
                      decoration: outerBorder,
                      child: Column(children: [
                        divider('STEP 1', '선호하는 장르 5개를 선택해주세요'),
                        defaultSpacer,
                        Container(
                            decoration: outerBorder,
                            height: 180,
                            width: _width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return sampleCard();
                              },
                            ))
                      ])),
                  // 아티스트
                  Container(
                      padding: defaultPadding,
                      alignment: Alignment.topLeft,
                      width: _width,
                      height: 250,
                      decoration: outerBorder,
                      child: Column(children: [
                        divider('STEP 2', '좋아하는 아티스트 5명을 선택해주세요'),
                        defaultSpacer,
                        Container(
                            decoration: outerBorder,
                            height: 180,
                            width: _width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return sampleCard();
                              },
                            ))
                      ])),
                  // 음원
                  Container(
                      padding: defaultPadding,
                      alignment: Alignment.topLeft,
                      width: _width,
                      height: 250,
                      decoration: outerBorder,
                      child: Column(children: [
                        divider('STEP 1', '선호하는 음원 5개를 선택해주세요'),
                        defaultSpacer,
                        Container(
                            decoration: outerBorder,
                            height: 180,
                            width: _width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return sampleCard();
                              },
                            ))
                      ])),
                ],
              ),
            ),
          ),
          const Spacer(),
          footer()
        ])));
  }
}
