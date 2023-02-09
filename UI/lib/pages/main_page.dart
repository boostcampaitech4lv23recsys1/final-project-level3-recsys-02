import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/widgets/search_popup.dart';
import 'package:ui/widgets/track_detail.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_card.dart';
import 'package:ui/widgets/titlebar.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:ui/utils/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

Future<String> getUserName() async {
  final pref = await SharedPreferences.getInstance();
  var userId = pref.getString('user_id')!;
  return userId;
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var width;

  final _mainScrollCotroller = ScrollController();
  final fastSelectionController = ScrollController();
  final charController = ScrollController();
  final _tagRecController = ScrollController();
  final _artistRecController = ScrollController();

  final DioClient dioClient = DioClient();
  final DioModel dioModel = DioModel();

  String userId = '';
  String tag = '';
  String artist = '';
  Map profile_info = {};
  String realname = '';
  String image = '';

  List<Item> musicList = [];
  List<Item> tagList = [];
  List<Item> artistList = [];
  List<Item> chartList = [];

  List interChartList = [];
  List recMainList = [];
  List recTagList = [];
  List recArtList = [];
  List user = [];

  var tag_list_e = ['🍏', '🍎', '🍇', '🌽', '🥐', '🍟', '🍙', '🍡'];
  var emo = '';

  Future addInteraction(Item item) async {
    final pref = await SharedPreferences.getInstance();
    String userId = pref.getString('user_id')!;

    await dioClient.interactionClick(
      userId: userId,
      trackId: item.trackId,
      album_name: item.albumName,
    );
  }

  void getProfile() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id')!;

    profile_info = await dioClient.profile(name: userId.toString());

    realname = profile_info['realname'];
    image = profile_info['image'];

    setState(() {});
  }

  void getChartList() async {
    List interChartList = await dioClient.getDailyChart();
    for (int i = 0; i < interChartList.length; i++) {
      chartList.add(Item(
          trackId: interChartList[i][0],
          image: interChartList[i][6],
          trackName: interChartList[i][1],
          albumName: interChartList[i][2],
          artistName: interChartList[i][3],
          duration: interChartList[i][4],
          url: interChartList[i][5]));
    }
    setState(() {});
  }

  void getTasts() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id')!;

    List tasts = await dioClient.get_usertasts(userId);

    List tag_list = [
      'acoustic',
      'alternative',
      'blues',
      'classical',
      'country',
      'dance',
      'electronic',
      'hardcore',
      'hip-hop',
      'indie',
      'jazz',
      'k-pop',
      'metal',
      'pop',
      'punk',
      'rap',
      'reggae',
      'rnb',
      'rock',
      'soul'
    ];

    List art_list = [
      '10 Years',
      '100 gecs',
      '1000 Clowns',
      '10cc',
      '112',
      '12 Rods',
      '12 Stones',
      '1208',
      '123'
    ];
    int min = 0;
    int max = 19;

    Random random = new Random();
    int randomInt = min + random.nextInt(max - min + 1);

    if (tasts[0] == null) {
      tag = tag_list[randomInt];
    } else {
      tag = tasts[0][0];
    }
    min = 0;
    max = 8;

    randomInt = min + random.nextInt(max - min + 1);
    if (tasts[1] == null) {
      artist = art_list[randomInt];
    } else {
      artist = tasts[1];
    }

    setState(() {});
  }

  void getMusicList() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id')!;
    // print(userId);
    Map recomlist = await dioModel.recMusic(name: userId);

    List temp = [recomlist['main'], recomlist['tag'], recomlist['artist']];
    for (int i = 0; i < temp.length; i++) {
      for (int j = 0; j < temp[i].length; j++) {
        if (temp[i][j][1] == null) {
          int rnum = Random().nextInt(4);
          temp[i][j][1] = 'assets/album0.png';
        }
        for (int k = 2; k < 7; k++) {
          if (temp[i][j][k] == null) {
            temp[i][j][k] = 'No data';
          }
        }
      }
    }

    recMainList = temp[0];
    recTagList = temp[1];
    recArtList = temp[2];

    recMainList.shuffle();
    recTagList.shuffle();
    recArtList.shuffle();

    musicList.clear();
    tagList.clear();
    artistList.clear();

    for (int i = 0; i < 20; i++) {
      musicList.add(Item(
          trackId: recMainList[i][0],
          image: recMainList[i][1],
          trackName: recMainList[i][2],
          albumName: recMainList[i][3],
          artistName: recMainList[i][4],
          duration: recMainList[i][5],
          url: recMainList[i][6]));

      tagList.add(Item(
          trackId: recTagList[i][0],
          image: recTagList[i][1],
          trackName: recTagList[i][2],
          albumName: recTagList[i][3],
          artistName: recTagList[i][4],
          duration: recTagList[i][5],
          url: recTagList[i][6]));

      artistList.add(Item(
          trackId: recArtList[i][0],
          image: recArtList[i][1],
          trackName: recArtList[i][2],
          albumName: recArtList[i][3],
          artistName: recArtList[i][4],
          duration: recArtList[i][5],
          url: recArtList[i][6]));
    }
    Random random = new Random();
    int randomInt = random.nextInt(7 - 0 + 1);
    emo = tag_list_e[randomInt];

    setState(() {});
  }

  @override
  void initState() {
    getMusicList();
    getChartList();
    getTasts();
    getProfile();
    super.initState();
  }

  Widget musicRank() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar(
        '인기곡',
      ),
      SizedBox(
          height: boxHeight * 1.2,
          width: width * 0.8,
          child: AlignedGridView.count(
            controller: charController,
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: chartList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    addInteraction(chartList[index]);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) =>
                            DetailPage(item: chartList[index]),
                      ),
                    );
                  },
                  child: trackCard(chartList[index],
                      isRank: true, index: index + 1));
            },
          )),
    ]);
  }

  // 빠른 선곡
  Widget fastSelection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircleAvatar(
              backgroundColor: kBlack,
              backgroundImage: NetworkImage('$image'),
            ),
          ),
          Text("  " + "$realname 님 반갑습니다,", style: titleTextStyle3),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("빠른선곡", style: titleTextStyle2),
          IconButton(
              iconSize: 40,
              icon: const Icon(Icons.refresh_rounded),
              color: kWhite,
              onPressed: () {
                getMusicList();
                getTasts();
              }),
        ],
      ),
      SizedBox(
        height: 20,
        width: width * 0.8,
      ),
      SizedBox(
          height: boxHeight * 1.19,
          width: width * 0.8,
          child: AlignedGridView.count(
            controller: fastSelectionController,
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: musicList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    addInteraction(musicList[index]);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) =>
                            DetailPage(item: musicList[index]),
                      ),
                    );
                  },
                  child: trackCard(musicList[index]));
            },
          )),
    ]);
  }

  Widget recommendation(String title, List<Item> items, controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar(
        title,
      ),
      Container(
          //decoration: outerBorder,
          width: width * 0.8,
          height: boxHeight * 1.45,
          child: RawScrollbar(
              controller: controller,
              child: ListView.builder(
                controller: controller,
                padding: defaultPadding,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int idx) {
                  return GestureDetector(
                      onTap: () {
                        addInteraction(items[idx]);
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) =>
                                DetailPage(item: items[idx]),
                          ),
                        );
                      },
                      child: trackCoverCard(items[idx]));
                },
              )))
    ]);
  }

  AppBar mainAppBar(context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: kBlack,
      elevation: 0,
      leading: ElevatedButton(
        style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(12)),
        child: Image.asset(
          'assets/logo.png',
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/main');
        },
      ),
      leadingWidth: 200,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: buttonWidth,
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: kBlack,
                  // side: whiteBorder,
                  padding: const EdgeInsets.all(12)),
              child: Text('홈', style: subtitleTextStyle),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: kBlack,
                  elevation: 0,
                  padding: const EdgeInsets.all(12)),
              child: Text('마이페이지', style: subtitleTextStyle),
              onPressed: () {
                Navigator.pushNamed(context, '/mypage');
              },
            ),
          ),
          Container(
            width: buttonWidth,
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: kBlack,
                  elevation: 0,
                  padding: const EdgeInsets.all(12)),
              child: Text('검색하기', style: subtitleTextStyle),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => SearchBar()),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        Container(
            width: buttonWidth * 1.2,
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: kBlack,
                  elevation: 0,
                  padding: const EdgeInsets.all(12)),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundColor: kBlack,
                      backgroundImage: NetworkImage('$image'),
                    ),
                  ),
                  Text("  " + "로그아웃", style: subtitleTextStyle),
                ],
              ),
              onPressed: () {
                exitSession();
                setState(() {});
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: mainAppBar(context),
        body: Container(
            padding: outerPadding,
            alignment: Alignment.topCenter,
            child: WebSmoothScroll(
              controller: _mainScrollCotroller,
              scrollOffset: 100,
              animationDuration: 600,
              curve: Curves.easeInOutCirc,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _mainScrollCotroller,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    fastSelection(),
                    defaultSpacer,
                    // musicRank(),
                    // defaultSpacer,
                    defaultSpacer,
                    defaultSpacer,
                    recommendation(
                        '$tag 장르를 좋아한다면 $emo', tagList, _tagRecController),
                    defaultSpacer,
                    defaultSpacer,
                    defaultSpacer,
                    recommendation('$artist 아티스트를 좋아한다면', artistList,
                        _artistRecController),
                    defaultSpacer,
                    defaultSpacer,
                    defaultSpacer,
                    musicRank(),
                    defaultSpacer,
                    defaultSpacer,
                    footer(),
                    defaultSpacer,
                  ],
                ),
              ),
            )));
  }
}
