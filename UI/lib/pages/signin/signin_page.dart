import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/home_page.dart';
import 'package:ui/pages/signin/prefer_input.dart';
import 'package:ui/pages/signin/userinfo_input.dart';
import 'package:ui/widgets/footer.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isStart = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'logo.png',
                  ),
                  Container(
                      width: width * 0.7,
                      height: height * 0.72,
                      decoration: outerBorder,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 20),
                      child: Column(children: [
                        isStart
                            ? const UserInfoInput()
                            : const PrefernceInput(),
                        defaultSpacer,
                        isStart
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: buttonWidth,
                                      height: titleHeight,
                                      child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: kWhite,
                                            side: whiteBorder,
                                            padding: const EdgeInsets.all(16)),
                                        child: Text('이전',
                                            style: TextStyle(
                                              color: kDarkGrey,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () {},
                                      )),
                                  defaultSpacer,
                                  SizedBox(
                                      width: buttonWidth,
                                      height: titleHeight,
                                      child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: kWhite,
                                            side: whiteBorder,
                                            padding: const EdgeInsets.all(16)),
                                        child: Text('다음',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () {
                                          isStart = false;
                                          setState(() {});
                                        },
                                      )),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: buttonWidth,
                                      height: titleHeight,
                                      child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: kWhite,
                                            side: whiteBorder,
                                            padding: const EdgeInsets.all(16)),
                                        child: Text('이전',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () {
                                          isStart = true;
                                          setState(() {});
                                        },
                                      )),
                                  defaultSpacer,
                                  Container(
                                      width: buttonWidth,
                                      height: titleHeight,
                                      child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: kWhite,
                                            side: whiteBorder,
                                            padding: const EdgeInsets.all(16)),
                                        child: Text('가입',
                                            style: TextStyle(
                                              color: kBlack,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        },
                                      )),
                                ],
                              ),
                      ])),
                  const Spacer(),
                  footer()
                ])));
  }
}
