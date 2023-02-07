import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/user.dart';
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

  late UserInfo userInfo;
  late TextEditingController _nameController;
  late TextEditingController _emailCheckController;
  late TextEditingController _pwdController;
  late TextEditingController _realnameController;
  late TextEditingController _ageController;

  final DioClient dioClient = DioClient();
  final List imageList = [
    'assets/profile1.png',
    'assets/profile2.png',
    'assets/profile3.png',
    'assets/profile4.png',
    'assets/profile5.png',
    'assets/profile6.png',
  ];
  String msg = '';

  String selectedProfileImage = '-1';

  final List genreLists = [
    ['jazz', false],
    ['pop', false],
    ['dance', false],
    ['rock', false],
    ['electronic', false],
    ['rap', false],
    ['hip-hop', false],
    ['country', false],
    ['blues', false],
    ['classical', false],
    ['k-pop', false],
    ['metal', false],
    ['rnb', false],
    ['reggae', false],
    ['acoustic', false],
    ['indie', false],
    ['alternative', false],
    ['punk', false],
    ['hardcore', false],
    ['soul', false],
  ];
  final List<String> selectedGenreLists = [];

  final List artistList = [];
  final List<String> selectedArtistList = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailCheckController = TextEditingController();
    _pwdController = TextEditingController();
    _realnameController = TextEditingController();
    _ageController = TextEditingController();

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

    super.dispose();
  }

  void getArtists() async {
    var res = await dioClient.getArtists();
    for (var r in res) {
      artistList.add([r['artist_name'], false]);
    }
    setState(() {});
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
            Text(
              '프로필 사진 $msg',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 180,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                // decoration: outerBorder,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 30,
                    childAspectRatio: 1,
                  ),
                  itemCount: imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          msg = ': ${index + 1}번째 이미지가 선택되었습니다 ! ';
                          selectedProfileImage = imageList[index];
                          setState(() {});
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(imageList[index]),
                        ));
                  },
                )),
            defaultSpacer,
            // 사용자 이름 입력
            Text(
              '프로필 이름',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            Container(
                margin: EdgeInsets.only(bottom: 7),
                child: Text(
                  '최대 5자까지 가능해요',
                  style: hintTextStyle,
                )),
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
                style: TextStyle(color: kWhite),
              ),
            ),
            defaultSpacer,
            // 이메일 입력
            Text(
              '아이디',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            Container(
                margin: EdgeInsets.only(bottom: 7),
                child:
                    Text('6-10자의 영문 소문자, 숫자를 사용해주세요. ', style: hintTextStyle)),
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
                style: TextStyle(color: kWhite),
              ),
            ),
            defaultSpacer,
            // 비밀번호 입력
            Text(
              '비밀번호',
              style: subtitleTextStyle,
              textAlign: TextAlign.start,
            ),
            Container(
                margin: EdgeInsets.only(bottom: 7),
                child:
                    Text('6-10자의 영문 소문자, 숫자를 사용해주세요. ', style: hintTextStyle)),
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
                style: TextStyle(color: kWhite),
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
                style: TextStyle(color: kWhite),
              ),
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
                              selectedGenreLists.remove(genreLists[index][0]);
                            } else {
                              genreLists[index][1] = true;
                              selectedGenreLists.add(genreLists[index][0]);
                            }
                            setState(() {});
                          }),
                      signinItemCard(genreLists[index]),
                    ],
                  ));
            },
          )),
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
          height: boxHeight,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          // decoration: outerBorder,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1 / 0.2,
            ),
            itemCount: artistList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  decoration: outerBorder,
                  child: Row(
                    children: [
                      GestureDetector(
                          child: Container(
                              width: 25,
                              decoration: BoxDecoration(
                                color: artistList[index][1]
                                    ? Color.fromARGB(255, 255, 146, 127)
                                    : kWhite,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    bottomLeft: Radius.circular(6.0)),
                              )),
                          onTap: () {
                            if (artistList[index][1]) {
                              artistList[index][1] = false;
                              selectedArtistList.remove(artistList[index][0]);
                            } else {
                              artistList[index][1] = true;
                              selectedArtistList.add(artistList[index][0]);
                            }
                            setState(() {});
                          }),
                      signinItemCard(artistList[index]),
                    ],
                  ));
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
                  GestureDetector(
                    child: Container(
                      height: 100,
                      child: Image.asset(
                        'logo.png',
                      ),
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
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
                                          // 입력 유효성 체크
                                          RegExp pattern =
                                              RegExp(r'[a-z0-9]{6,10}');

                                          String userInfoError = '';

                                          // 0. 프로필 이미지
                                          if (selectedProfileImage == '-1') {
                                            userInfoError = '프로필 이미지를 선택해주세요.';
                                          }
                                          // 1. 프로필명 형식 판단
                                          if (_realnameController
                                                  .text.isEmpty &&
                                              _nameController.text.length > 5) {
                                            userInfoError =
                                                '프로필 이름 입력형식을 다시 확인해주세요.';
                                          }

                                          // 2. 아이디 형식 판단
                                          if (!(pattern.hasMatch(
                                              _nameController.text))) {
                                            userInfoError =
                                                '아이디 입력형식을 다시 확인해주세요.';
                                          }

                                          // 3. 비밀번호 형식 판단
                                          if (!(pattern
                                              .hasMatch(_pwdController.text))) {
                                            userInfoError =
                                                '비밀번호 입력형식을 다시 확인해주세요.';
                                          }

                                          // 4. 나이 형식 판단
                                          // 나이가 음수가 아니거나, 너무 크다거나 하는 등의 기준은 포함되어있지 않음
                                          int ageParsed = 0;
                                          try {
                                            ageParsed =
                                                int.parse(_ageController.text);
                                          } catch (e) {
                                            userInfoError =
                                                '나이 입력형식을 다시 확인해주세요.';
                                          }

                                          if (userInfoError == '') {
                                            isStart = false;
                                            setState(() {});
                                            userInfo = UserInfo(
                                              userId: -1,
                                              user_name: _nameController.text,
                                              password: _pwdController.text,
                                              realname:
                                                  _realnameController.text,
                                              image: selectedProfileImage,
                                              age: ageParsed,
                                              playcount: 0,
                                              follower: [],
                                              following: [],
                                            );
                                          } else {
                                            Toast.show(userInfoError,
                                                backgroundColor: kWhite,
                                                textStyle:
                                                    TextStyle(color: kBlack),
                                                gravity: Toast.top,
                                                duration: Toast.lengthLong);
                                          }
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
                                          if (selectedGenreLists.length >= 3 &&
                                              selectedArtistList.length >= 3) {
                                            var res =
                                                await dioClient.signinUser(
                                                    userInfo: userInfo,
                                                    tags: selectedGenreLists,
                                                    artists:
                                                        selectedArtistList);
                                            debugPrint(
                                                'signinpage response: $res');
                                            if (res == 'False') {
                                              Toast.show('이미 가입하신 내역이 존재합니다.',
                                                  backgroundColor: kWhite,
                                                  textStyle:
                                                      TextStyle(color: kBlack),
                                                  gravity: Toast.top,
                                                  duration: Toast.lengthLong);
                                            } else if (res == 'Error') {
                                              Toast.show(
                                                  '입력하신 사항들을 다시 한 번 확인해주세요 !',
                                                  backgroundColor: kWhite,
                                                  textStyle:
                                                      TextStyle(color: kBlack),
                                                  gravity: Toast.top,
                                                  duration: Toast.lengthLong);
                                            } else if (res == 'True') {
                                              Toast.show('회원가입을 완료하였습니다.',
                                                  backgroundColor: kWhite,
                                                  textStyle:
                                                      TextStyle(color: kBlack),
                                                  gravity: Toast.top,
                                                  duration: Toast.lengthLong);
                                              Navigator.pushNamed(
                                                  context, '/home');
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
