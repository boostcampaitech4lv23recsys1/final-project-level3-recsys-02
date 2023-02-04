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
import 'package:shared_preferences/shared_preferences.dart';

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
  final recController = ScrollController();
  final DioClient dioClient = DioClient();
  final DioModel dioModel = DioModel();

  String userId = '';

  List<Item> musicList = [];
  List<Item> tagList = [];
  List<Item> artistList = [];
  List<Item> recList = [];

  List recMainList = [];
  List recTagList = [];
  List recArtList = [];
  List user = [];

  Future addInteraction(Item item) async {
    await dioClient.interactionClick(
      userId: getUserName() as String,
      trackId: item.trackId,
    );
  }

  void getMusicList() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString('user_id')!;

    Map recomlist = await dioModel.recMusic(name: userId);

    List temp = [recomlist['main'], recomlist['tag'], recomlist['artist']];
    for (int i = 0; i < temp.length; i++) {
      for (int j = 0; j < temp[i].length; j++) {
        if (temp[i][j][1] == null) {
          temp[i][j][1] = 'assets/album.png';
        }
        for (int k = 2; k < 6; k++) {
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
          duration: recMainList[i][5]));

      tagList.add(Item(
          trackId: recTagList[i][0],
          image: recTagList[i][1],
          trackName: recTagList[i][2],
          albumName: recTagList[i][3],
          artistName: recTagList[i][4],
          duration: recTagList[i][5]));

      artistList.add(Item(
          trackId: recArtList[i][0],
          image: recArtList[i][1],
          trackName: recArtList[i][2],
          albumName: recArtList[i][3],
          artistName: recArtList[i][4],
          duration: recArtList[i][5]));
    }
    setState(() {});
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
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("빠른선곡", style: titleTextStyle),
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              color: kWhite,
              onPressed: () {
                getMusicList();
              }),
        ],
      ),
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

  Widget recommendation(String title, List<Item> items) {
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
          ))
    ]);
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
                    recommendation('00 장르를 좋아한다면', tagList),
                    defaultSpacer,
                    recommendation('00 아티스트를 좋아한다면', artistList),
                    defaultSpacer,
                    recommendation('00 노래를 좋아한다면', recList),
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
