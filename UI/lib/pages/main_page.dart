import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/widgets/album_detail.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/custom_card.dart';
import 'package:ui/widgets/titlebar.dart';

class OtherUser {
  var image;
  String name;
  int followerNum;
  bool isFollowing;

  OtherUser(
      {this.image = 'profile.png',
      required this.name,
      required this.followerNum,
      required this.isFollowing});
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Item> musicList = [];
  List<Item> albumList = [];
  List<OtherUser> userList = [];

  void getMusicRec() {
    for (int i = 0; i < 10; i++) {
      musicList.add(Item(
        image: 'album.png',
        name: 'Track Name $i',
        artistName: 'Artist Name $i',
      ));
    }
  }

  void getUserRec() {
    for (int i = 0; i < 5; i++) {
      userList.add(OtherUser(
        name: 'user $i',
        followerNum: i,
        isFollowing: false,
      ));
    }
  }

  void getNewAlbums() {
    for (int i = 0; i < 10; i++) {
      albumList.add(Item(
        image: 'album.png',
        name: 'Album Name $i',
        artistName: 'Artist Name $i',
        release: '2022.01.17',
      ));
    }
  }

  @override
  void initState() {
    getMusicRec();
    getNewAlbums();
    getUserRec();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var width = MediaQuery.of(context).size.width;

    final musicController = ScrollController();
    final albumController = ScrollController();
    final userController = ScrollController();
    final charController = ScrollController();
    return Scaffold(
        body: Padding(
            padding: outerPadding,
            child: Column(children: [
              customHeader(context, true),
              defaultSpacer,
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 빠른 선곡
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleBar(width * 0.5, '빠른 선곡'),
                          Container(
                              decoration: outerBorder,
                              height: boxHeight - 25,
                              width: width * 0.5,
                              child: RawScrollbar(
                                  controller: musicController,
                                  child: ListView.builder(
                                    padding: defaultPadding,
                                    scrollDirection: Axis.horizontal,
                                    controller: musicController,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: musicList.length,
                                    itemBuilder:
                                        (BuildContext context, int idx) {
                                      return Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          playlistCard(musicList[idx]),
                                          Positioned(
                                              top: 3,
                                              right: 3,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Toast.show(
                                                      "'나의 재생목록'에 추가되었습니다.",
                                                      gravity: Toast.top,
                                                      webTexColor: kBlack,
                                                    );
                                                  },
                                                  icon: Icon(
                                                      Icons.favorite_rounded,
                                                      color: kBlack)))
                                        ],
                                      );
                                    },
                                  ))),
                        ]),
                    const Spacer(),
                    // 인기곡
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleBar(width * 0.4, '인기곡'),
                          Container(
                              decoration: outerBorder,
                              width: width * 0.4,
                              height: boxHeight - 25,
                              child: RawScrollbar(
                                  controller: charController,
                                  child: ListView.builder(
                                    controller: charController,
                                    padding: defaultPadding,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Center(
                                        child: chartCard(index + 1),
                                      );
                                    },
                                  )))
                        ]),
                  ]),
              defaultSpacer,
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                // 최신앨범
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.5, '최신앨범'),
                  Container(
                      decoration: outerBorder,
                      width: width * 0.5,
                      height: boxHeight,
                      child: RawScrollbar(
                          controller: albumController,
                          child: ListView.builder(
                            controller: albumController,
                            padding: defaultPadding,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int idx) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false, // set to false
                                        pageBuilder: (_, __, ___) =>
                                            DetailPage(item: albumList[idx]),
                                      ),
                                    );
                                  },
                                  child: albumCard(albumList[idx]));
                            },
                          )))
                ]),
                const Spacer(),
                // 비슷한 유저 추천
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.4, '친구 추천', isReset: true),
                  Container(
                      decoration: outerBorder,
                      height: boxHeight,
                      width: width * 0.4,
                      child: RawScrollbar(
                          controller: userController,
                          child: ListView.builder(
                            padding: defaultPadding,
                            controller: userController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: userList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    // Widget userCard(image, name, follower) {
                                    userCard(
                                        userList[index].image,
                                        userList[index].name,
                                        userList[index].followerNum),
                                    Positioned(
                                      bottom: 15,
                                      child: userList[index].isFollowing
                                          ? OutlinedButton(
                                              onPressed: () {
                                                userList[index].isFollowing =
                                                    false;
                                                setState(() {});
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: kWhite,
                                                side: whiteBorder,
                                              ),
                                              child: Text('팔로잉',
                                                  style: TextStyle(
                                                      color: kBlack,
                                                      fontSize: 12.0),
                                                  textAlign: TextAlign.center))
                                          : OutlinedButton(
                                              onPressed: () {
                                                userList[index].isFollowing =
                                                    true;
                                                setState(() {});
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                side: whiteBorder,
                                              ),
                                              child: Text('팔로우',
                                                  style: defaultTextStyle,
                                                  textAlign: TextAlign.center)),
                                    )
                                  ]);
                            },
                          ))),
                ]),
              ]),
              const Spacer(),
              footer()
            ])));
  }
}
