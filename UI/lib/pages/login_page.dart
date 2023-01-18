import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/pages/signin_page.dart';
import 'package:ui/widgets/footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var idTextController = TextEditingController();
  var pwdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: outerPadding,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  Image.asset(
                    'logo.png',
                    width: 300,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                  Container(
                      width: 600,
                      height: 300,
                      decoration: outerBorder,
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            textAlign: TextAlign.center,
                            controller: idTextController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: '아이디',
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    borderSide: whiteBorder),
                                filled: true,
                                contentPadding: const EdgeInsets.all(16),
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                          TextField(
                            textAlign: TextAlign.center,
                            controller: pwdTextController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: '비밀번호',
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    borderSide: whiteBorder),
                                filled: true,
                                contentPadding: const EdgeInsets.all(16),
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.password)),
                          ),
                          defaultSpacer,
                          defaultSpacer,
                          Container(
                              width: buttonWidth * 4.5,
                              height: titleHeight,
                              child: ElevatedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: kWhite,
                                    side: whiteBorder,
                                    padding: const EdgeInsets.all(16)),
                                child: Text('로그인하기',
                                    style: TextStyle(
                                      color: kBlack,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onPressed: () {},
                              )),
                          defaultSpacer,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              defaultSpacer,
                              TextButton(
                                child: Text('아이디찾기',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 14.0,
                                    )),
                                onPressed: () {},
                              ),
                              Text(
                                '|',
                                style: TextStyle(color: kWhite),
                              ),
                              TextButton(
                                child: Text('비밀번호찾기',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 14.0,
                                    )),
                                onPressed: () {},
                              ),
                              Text(
                                '|',
                                style: TextStyle(color: kWhite),
                              ),
                              TextButton(
                                child: Text('회원가입',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 14.0,
                                    )),
                                onPressed: () {},
                              ),
                              defaultSpacer,
                            ],
                          ),
                        ],
                      )),
                  const Spacer(flex: 2),
                  footer()
                ])));
  }
}
