import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  late TextEditingController _nameController;
  late TextEditingController _emailCheckController;
  late TextEditingController _pwdController;
  late TextEditingController _realnameController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;

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

  String selectedProfileImage = 'assets/profile.png';
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
    ['etc', false],
  ];
  final List<String> selectedGenreLists = [];

  final List artistList = [];
  final List<String> selectedArtistList = [];

  var selectedGender = '성별';
  var genders = ['성별', '남성', '여성', '기타'];
  var selectedCountry = '거주국가';
  var countries = ['거주국가', '대한민국'];

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
                height: 135,
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
            defaultSpacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: titleHeight,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: outerBorder,
                      child: DropdownButton(
                        value: selectedGender,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        dropdownColor: kBlack,
                        items: genders.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(color: kWhite),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                defaultSpacer,
                defaultSpacer,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: titleHeight,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: outerBorder,
                      child: DropdownButton(
                        value: selectedCountry,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        isExpanded: true,
                        dropdownColor: kBlack,
                        items: countries.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(color: kWhite),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCountry = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
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
                                            user_name: _nameController.text,
                                            password: _pwdController.text,
                                            realname: _realnameController.text,
                                            image: selectedProfileImage,
                                            country: selectedCountry,
                                            age: int.parse(_ageController.text),
                                            gender:
                                                genders.indexOf(selectedGender),
                                            playcount: 0,
                                            follower: [''],
                                            following: [''],
                                          );

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
