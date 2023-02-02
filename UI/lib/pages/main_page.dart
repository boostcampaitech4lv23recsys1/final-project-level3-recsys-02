import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import 'package:ui/constants.dart';
import 'package:ui/main.dart';
import 'package:ui/models/item.dart';
import 'package:ui/widgets/track_detail.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/custom_card.dart';
import 'package:ui/widgets/titlebar.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:ui/utils/dio_client.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var width;

  final _mainScrollCotroller = ScrollController();
  final fastSelectionController = ScrollController();
  final charController = ScrollController();
  final recController = ScrollController();
  final DioClient dioClient = DioClient();

  List<Item> musicList = [];
  List<Item> recList = [];

  Future addInteraction(Item item) async {
    await dioClient.interactionClick(

        userId: userid,
        trackId: item.trackId,
        );
  }

  void getMusicList() {
    for (int i = 0; i < 20; i++) {
      musicList.add(Item(
          trackId: i,
          image: 'assets/album.png',
          trackName: 'Track Name $i',
          albumName: 'Album Name $i',
          artistName: 'Artist Name $i',
          duration: 24000));
    }
  }

  void getRecList() {
    for (int i = 0; i < 9; i++) {
      recList.add(Item(
          trackId: i,
          image: 'assets/album.png',
          trackName: 'Track Name $i',
          albumName: 'Album Name $i',
          artistName: 'Artist Name $i',
          duration: 24000));
    }
  }

  @override
  void initState() {
    getMusicList();
    getRecList();
    super.initState();
  }

  Widget musicRank() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar(
        '인기곡',
      ),
      SizedBox(
          height: boxHeight,
          width: width * 0.8,
          child: AlignedGridView.count(
            controller: charController,
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
                  child: trackCard(musicList[index],
                      isRank: true, index: index + 1));
            },
          )),
    ]);
  }

  // 빠른 선곡
  Widget fastSelection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar('빠른 선곡', isReset: true),
      SizedBox(
          height: boxHeight,
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

  Widget recommendation(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar(
        title,
      ),
      Container(
          decoration: outerBorder,
          width: width * 0.8,
          height: boxHeight,
          child: AlignedGridView.count(
            crossAxisCount: 1,
            mainAxisSpacing: 20,
            controller: recController,
            padding: defaultPadding,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recList.length,
            itemBuilder: (BuildContext context, int idx) {
              return GestureDetector(
                  onTap: () {
                    addInteraction(recList[idx]);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) =>
                            DetailPage(item: recList[idx]),
                      ),
                    );
                  },
                  child: trackCoverCard(recList[idx]));
            },
          ))
    ]);
  }

  AppBar mainAppBar(context) {
    return AppBar(
      toolbarHeight: 80,
      elevation: 0,
      backgroundColor: kBlack,
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
      title: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: TextField(
            textAlign: TextAlign.center,
            // controller: textcontroller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: '원하시는 노래를 검색하세요',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: whiteBorder),
                filled: true,
                contentPadding: const EdgeInsets.all(12),
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search)),
          )),
      titleSpacing: 20,
      actions: [
        Container(
          width: buttonWidth,
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: whiteBorder,
                padding: const EdgeInsets.all(12)),
            child: Text('마이페이지', style: subtitleTextStyle),
            onPressed: () {
              // list<str> = likesList;
              // userInfo = profile;

              Navigator.pushNamed(context, '/mypage');
            },
          ),
        ),
        Container(
            width: buttonWidth,
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: whiteBorder,
                  padding: const EdgeInsets.all(12)),
              child: Text('로그아웃', style: subtitleTextStyle),
              onPressed: () {
                exitSession();
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
                    musicRank(),
                    defaultSpacer,
                    recommendation('00 장르를 좋아한다면'),
                    defaultSpacer,
                    recommendation('00 아티스트를 좋아한다면'),
                    defaultSpacer,
                    recommendation('00 노래를 좋아한다면'),
                    defaultSpacer,
                    footer(),
                    defaultSpacer,
                    defaultSpacer,
                  ],
                ),
              ),
            )));
  }
}
