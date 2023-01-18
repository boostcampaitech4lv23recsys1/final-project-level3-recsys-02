import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/user.dart';
import 'package:ui/pages/main_page.dart';
import 'package:ui/utils/dio_client.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_card.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isStart = true;

  late TextEditingController _emailController;
  late TextEditingController _emailCheckController;
  late TextEditingController _pwdController;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  final DioClient dioClient = DioClient();

  @override
  void initState() {
    _emailController = TextEditingController();
    _emailCheckController = TextEditingController();
    _pwdController = TextEditingController();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailCheckController.dispose();
    _pwdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();

    super.dispose();
  }

  Widget userInfoInput() {
    return Expanded(
        // height: 580,
        // width: MediaQuery.of(context).size.width,
        // decoration: outerBorder,
        child: ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이메일 입력
            Text(
              '이메일이 어떻게 되시나요?',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '이메일을 입력하세요.'),
                controller: _emailController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 이메일 다시 입력
            Text(
              '이메일이 어떻게 되시나요?',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '이메일을 입력하세요.'),
                controller: _emailCheckController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 비밀번호 입력
            Text(
              '비밀번호를 만드세요.',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '비밀번호를 만드세요.'),
                controller: _pwdController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 사용자 이름 입력
            Text(
              '어떤 사용자 이름을 사용하시겠어요?.',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '프로필 이름을 입력하세요.'),
                controller: _nameController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 나이 입력
            Text(
              '나이가 어떻게 되사나요?',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '나이를 입력하세요.'),
                controller: _ageController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 성별 입력
            Text(
              '성별이 무엇인가요? (1: 남성, 2: 여성, 3: 기타, 4: 답변거부) 확인하세요.',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: titleHeight,
              decoration: outerBorder,
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '(예시) 2'),
                controller: _genderController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer
          ],
        )
      ],
    ));
  }

  Widget prefernceInput() {
    return Expanded(
        // height: 580,
        // width: MediaQuery.of(context).size.width,
        // decoration: outerBorder,
        child: ListView(
      children: [
        Text('선호하시는 분위기 및 장르 5개를 선택해주세요', style: subtitleTextStyle),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: outerBorder,
            height: boxHeight - 20,
            child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 0.2,
              children: [
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
              ],
            )),
        defaultSpacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('선호하시는 아티스트 5명을 선택해주세요', style: subtitleTextStyle),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: kWhite))
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            decoration: outerBorder,
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return artistCard();
              },
            )),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'logo.png',
                  ),
                  Container(
                      width: width * 0.7,
                      height: height * 0.75,
                      decoration: outerBorder,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 45, vertical: 20),
                      child: Column(children: [
                        isStart ? userInfoInput() : prefernceInput(),
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
                                        onPressed: () async {
                                          isStart = false;
                                          setState(() {});

                                          User userInfo = User(
                                            email: _emailController.text,
                                            name: _nameController.text,
                                            pwd: _pwdController.text,
                                            age: int.parse(_ageController.text),
                                            gender: int.parse(
                                                _genderController.text),
                                            profileImage: 'assets/profile.png',
                                          );
                                          User? retrievedUser = await dioClient
                                              .createUser(user: userInfo);
                                          debugPrint(retrievedUser.toString());
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
                                                      MainPage()));
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
