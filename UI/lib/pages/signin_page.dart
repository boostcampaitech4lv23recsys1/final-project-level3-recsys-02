import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
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

  late TextEditingController _nameController;
  late TextEditingController _emailCheckController;
  late TextEditingController _pwdController;
  late TextEditingController _realnameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

  final DioClient dioClient = DioClient();

  final List genreLists = [
    ['electronic', false],
    ['metal', false],
    ['rock', false],
    ['hip-hop', false],
    ['indie', false],
    ['jazz', false],
    ['reggae', false],
    ['british', false],
    ['punk', false],
    ['80s', false],
    ['dance', false],
    ['acoustic', false],
    ['rnb', false],
    ['hardcore', false],
    ['country', false],
    ['blues', false],
    ['alternative', false],
    ['classical', false],
    ['rap', false],
    ['country', false],
  ];
  final List selectedGenreLists = [];

  final List artistList = [];
  final List selectedArtistList = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailCheckController = TextEditingController();
    _pwdController = TextEditingController();
    _realnameController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    getArtists();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailCheckController.dispose();
    _pwdController.dispose();
    _realnameController.dispose();
    _ageController.dispose();
    _genderController.dispose();

    super.dispose();
  }

  void getArtists() {
    for (int i = 0; i < 16; i++) {
      artistList.add(['아티스트 $i', 'profile.png', false]);
    }
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
              '아이디',
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
                    hintStyle: hintTextStyle, hintText: '(예시) guest1234'),
                controller: _nameController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 비밀번호 입력
            Text(
              '비밀번호',
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
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: hintTextStyle, hintText: '(예시) guest1234'),
                controller: _pwdController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 사용자 이름 입력
            Text(
              '프로필 이름',
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
                    hintStyle: hintTextStyle, hintText: '(예시) guest'),
                controller: _realnameController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 나이 입력
            Text(
              '나이',
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
                    hintStyle: hintTextStyle, hintText: '(예시) 24'),
                controller: _ageController,
                style: TextStyle(color: kDarkGrey),
              ),
            ),
            defaultSpacer,
            // 성별 입력
            Text(
              '성별 (1: 남성, 2: 여성, 3: 기타)',
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
            defaultSpacer,
            // 성별 입력
            Text(
              '거주국가',
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
            ),
          ],
        )
      ],
    ));
  }

  Widget prefernceInput() {
    var artistController = ScrollController();
    return Expanded(
        child: ListView(children: [
      Text('선호하시는 분위기 및 장르 최소 3개를 선택해주세요', style: subtitleTextStyle),
      Container(
          height: boxHeight,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          // decoration: outerBorder,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1 / 0.2,
            ),
            itemCount: genreLists.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  decoration: outerBorder,
                  child: Row(
                    children: [
                      GestureDetector(
                          child: Container(
                              width: 25,
                              decoration: BoxDecoration(
                                color: genreLists[index][1]
                                    ? Color.fromARGB(255, 255, 146, 127)
                                    : kWhite,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0)),
                              )),
                          onTap: () {
                            if (genreLists[index][1]) {
                              genreLists[index][1] = false;
                              selectedGenreLists.remove(index);
                            } else {
                              genreLists[index][1] = true;
                              selectedGenreLists.add(index);
                            }
                            setState(() {});
                          }),
                      genreCard(genreLists[index]),
                    ],
                  ));
            },
          )),
      defaultSpacer,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('선호하시는 아티스트 최소 3명을 선택해주세요', style: subtitleTextStyle),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.refresh_rounded, color: kWhite))
        ],
      ),
      Container(
          margin: const EdgeInsets.all(10),
          decoration: outerBorder,
          height: 350,
          alignment: Alignment.center,
          child: AlignedGridView.count(
            controller: artistController,
            crossAxisCount: 8,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: artistList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  artistCard(artistList[index]),
                  Positioned(
                    top: 3,
                    left: 3,
                    child: IconButton(
                        onPressed: () {
                          if (artistList[index][2]) {
                            artistList[index][2] = false;
                            selectedArtistList.remove(artistList[index][0]);
                          } else {
                            artistList[index][2] = true;
                            selectedArtistList.add(artistList[index][0]);
                          }
                          setState(() {});
                        },
                        icon: artistList[index][2]
                            ? Icon(Icons.bookmark_rounded,
                                color: Color.fromARGB(255, 255, 146, 127))
                            : Icon(
                                Icons.bookmark_rounded,
                                color: kWhite,
                              )),
                  )
                ],
              );
            },
          )),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ToastContext().init(context);

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset(
                      'logo.png',
                    ),
                  ),
                  Container(
                      width: width * 0.7,
                      height: height * 0.8,
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
                                          // 입력 유효성 체크
                                          // 아아디 - 이메일형식

                                          // 비밀번호 - 6자리 이상

                                          // 사용자 이름 - 영문/한글만

                                          // 나이 - int형
                                          // gender -
                                          // 이미지 -
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
                                        onPressed: () async {
                                          UserInfo userInfo = UserInfo(
                                            name: _nameController.text,
                                            pwd: _pwdController.text,
                                            realname: _realnameController.text,
                                            image: 'assets/profile.png',
                                            country: 'Korea',
                                            age: int.parse(_ageController.text),
                                            gender: int.parse(
                                                _genderController.text),
                                            followers: [],
                                            following: [],
                                          );

                                          debugPrint(
                                              selectedGenreLists.toString());
                                          debugPrint(
                                              selectedArtistList.toString());

                                          if (selectedGenreLists.length >= 3 &&
                                              selectedArtistList.length >= 3) {
                                            var res = await dioClient
                                                .signinUser(userInfo: userInfo);
                                            if (res == 'success') {
                                              Navigator.pushNamed(
                                                  context, '/main');
                                            } else if (res == 'exist') {
                                              Toast.show('이미 가입하신 내역이 존재합니다.',
                                                  backgroundColor: kWhite,
                                                  textStyle:
                                                      TextStyle(color: kBlack),
                                                  gravity: Toast.top,
                                                  duration: Toast.lengthLong);
                                            } else {
                                              Toast.show(
                                                  '입력하신 사항들을 다시 한 번 확인해주세요 !',
                                                  backgroundColor: kWhite,
                                                  textStyle:
                                                      TextStyle(color: kBlack),
                                                  gravity: Toast.top,
                                                  duration: Toast.lengthLong);
                                            }
                                          } else {
                                            Toast.show(
                                                '장르와 아티스트 모두 3개 이상 선택해주세요',
                                                backgroundColor: kWhite,
                                                textStyle:
                                                    TextStyle(color: kBlack),
                                                gravity: Toast.top,
                                                duration: Toast.lengthLong);
                                          }
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
