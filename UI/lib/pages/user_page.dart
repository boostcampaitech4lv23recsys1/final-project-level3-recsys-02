import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/models/user.dart';
import 'package:ui/widgets/follow_list.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/custom_card.dart';
import 'package:ui/widgets/titlebar.dart';
import 'package:ui/widgets/track_detail.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, this.isMyPage = true});

  final isMyPage;
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var width;

  final _mainScrollCotroller = ScrollController();
  final _userScrollController = ScrollController();
  final _playlistScrollController = ScrollController();

  late List<Item> myPlaylist = [];
  late SharedPreferences pref;

  String name = 'GUEST';

  List<String> follower = [];
  List<String> following = [];
  int followerNum = 0;
  int followingNum = 0;
  int match = 85;

  List<OtherUser> userList = [];
  void getUserRec() {
    for (int i = 0; i < 10; i++) {
      userList.add(OtherUser(
        name: 'user $i',
        followerNum: i,
        isFollowing: false,
      ));
    }
  }

  void getProfile() async {
    // pref = await SharedPreferences.getInstance();

    // name = pref.getString('name')!;
    // follower = pref.getStringList('follower')!;
    // following = pref.getStringList('following')!;
    // followerNum = follower.length;
    // followingNum = following.length;
  }

  void getMyMusics() {
    for (int i = 0; i < 10; i++) {
      myPlaylist.add(Item(
          image: 'assets/album.png',
          trackName: 'Track Name $i',
          albumName: 'Album Name $i',
          artistName: 'Artist Name $i',
          duration: 24000));
    }
  }

  @override
  void initState() {
    getProfile();
    getMyMusics();
    getUserRec();
    super.initState();
  }

  Widget profile({isOther = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBar('내 정보'),
        Container(
          width: width * 0.25,
          height: boxHeight,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: outerBorder,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              width: 160,
              height: 160,
              child: CircleAvatar(
                backgroundColor: kBlack,
                backgroundImage: const AssetImage('assets/profile.png'),
              ),
            ),
            defaultSpacer,
            defaultSpacer,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name 님', style: titleTextStyle),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) => FollowListPage(
                            itemList: ['a', 'b', 'c'], // following,
                            isFollowing: true,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(16)),
                    child: Text('♥  팔로잉         $followingNum 명',
                        style: contentsTextStyle)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) => FollowListPage(
                            itemList: ['a', 'b', 'c'], // follower,
                            isFollowing: false,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(16)),
                    child: Text('♥  팔로워         $followerNum 명',
                        style: contentsTextStyle)),
                ElevatedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(16)),
                    child: Text('♥  취향매칭률      $match %',
                        style: contentsTextStyle)),
                // isOther
                //     ? ElevatedButton(
                //         onPressed: () {},
                //         style: OutlinedButton.styleFrom(
                //             backgroundColor: Colors.transparent,
                //             side: whiteBorder,
                //             padding: const EdgeInsets.all(16)),
                //         child: Text('팔로우하기', style: contentsTextStyle))
                //     : Container()
              ],
            )
          ]),
        )
      ],
    );
  }

  Widget userPlaylist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBar('나의 플레이리스트'),
        Container(
            height: boxHeight,
            decoration: outerBorder,
            child: AlignedGridView.count(
              controller: _playlistScrollController,
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: myPlaylist.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) =>
                              DetailPage(item: myPlaylist[index]),
                        ),
                      );
                    },
                    child: playlistCard(myPlaylist[index]));
              },
            )),
      ],
    );
  }

  Widget userRecommendation() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBar('$name와 취향이 비슷한 사용자'),
      Container(
          width: width,
          decoration: outerBorder,
          height: boxHeight + 15,
          child: AlignedGridView.count(
            crossAxisCount: 1,
            mainAxisSpacing: 15,
            controller: _userScrollController,
            padding: defaultPadding,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              return Stack(alignment: Alignment.bottomCenter, children: [
                // Widget userCard(image, name, follower) {
                userCoverCard(userList[index].image, userList[index].name,
                    userList[index].followerNum),
                Positioned(
                  bottom: 10,
                  child: userList[index].isFollowing
                      ? OutlinedButton(
                          onPressed: () {
                            userList[index].isFollowing = false;
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: kWhite,
                            side: whiteBorder,
                          ),
                          child: Text('팔로잉',
                              style: TextStyle(color: kBlack, fontSize: 11.0),
                              textAlign: TextAlign.center))
                      : OutlinedButton(
                          onPressed: () {
                            userList[index].isFollowing = true;
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            side: whiteBorder,
                          ),
                          child: Text('팔로우',
                              style: TextStyle(color: kWhite, fontSize: 11.0),
                              textAlign: TextAlign.center)),
                )
              ]);
            },
          ))
    ]);
  }

  Widget userAnalyze() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBar('$name님의 취향분석 결과'),
          Container(
              decoration: outerBorder,
              width: width,
              height: 590,
              child: Center(
                  child: Text(
                '취향분석 결과',
                style: titleTextStyle,
              )))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: mypagenAppBar(context),
        body: Container(
            // width: width,
            // height: 400,
            padding: outerPadding,
            child: Container(
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
                    Container(
                        child: Row(
                      children: [
                        //내정보
                        profile(),
                        defaultSpacer,
                        defaultSpacer,
                        // 내 플레이리스트
                        Expanded(
                          child: userPlaylist(),
                        )
                      ],
                    )),
                    defaultSpacer,
                    // 나와 비슷한 유저 추천
                    userRecommendation(),
                    defaultSpacer,
                    // 취향분석
                    userAnalyze(),
                    defaultSpacer,
                    footer(),
                    defaultSpacer,
                    defaultSpacer,
                  ],
                ),
              ),
            ))));
  }
}
