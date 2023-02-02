import 'dart:io';

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
import 'package:ui/utils/dio_client.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, this.isMyPage = true, this.otherUser});

  final isMyPage;
  final otherUser;

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
  final DioClient dio = DioClient();

  String userName = '';
  String realname = '';

  List<String> follower = [];
  List<String> following = [];
  int followerNum = 0;
  int followingNum = 0;
  int match = 85;
  Map profile_info = {};
  List likelist = [];

  List<OtherUser> userList = [];
  void getUserRec() {
    for (int i = 0; i < 10; i++) {
      userList.add(
        OtherUser(
            user_name: 'user$i',
            realname: 'user$i',
            image: 'assets/profile.png',
            following: [],
            follower: []),
      );
    }
  }

  Future getProfile() async {
    if (widget.isMyPage) {
      final pref = await SharedPreferences.getInstance();
      userName = pref.getString('user_name')!;

      profile_info = await dio.profile(name: userName);

      realname = profile_info['realname'];
      follower = List<String>.from(profile_info['follower']);
      following = List<String>.from(profile_info['following']);

      followerNum = profile_info['follower'].length;
      followingNum = profile_info['following'].length;
    } else {
      realname = widget.otherUser.realname;
      follower = List<String>.from(widget.otherUser.follower);
      following = List<String>.from(widget.otherUser.following);

      followerNum = follower.length;
      followingNum = following.length;
    }
    setState(() {});
  }

  Future getMyMusics() async {
    if (widget.isMyPage) {
      final pref = await SharedPreferences.getInstance();
      userName = pref.getString('user_name')!;
    } else {
      userName = widget.otherUser.user_name;
    }
    setState(() {});

    likelist = await dio.likesList(name: userName);
    for (int i = 0; i < likelist.length; i++) {
      if (likelist[i][4] == null) {
        likelist[i][4] = 'assets/album.png';
      }
      myPlaylist.add(Item(
          image: likelist[i][4],
          trackName: likelist[i][0],
          albumName: likelist[i][1],
          artistName: likelist[i][2],
          duration: likelist[i][3]));
    }
    setState(() {});
  }

  @override
  void initState() {
    if (widget.isMyPage) {
      getUserRec();
    }
    getProfile();
    getMyMusics();
    super.initState();
  }

  Widget profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBar('내 정보'),
        Container(
          width: 500,
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
                Text('$realname 님', style: titleTextStyle),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) => FollowListPage(
                            itemNameList: following,
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
                            itemNameList: follower,
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
                widget.isMyPage
                    ? defaultSpacer
                    : ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.all(16)),
                        child: Text('♥  취향매칭률      $match %',
                            style: contentsTextStyle)),
                Container(
                    width: 180,
                    child: widget.isMyPage
                        ? ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: whiteBorder,
                                padding: const EdgeInsets.all(12)),
                            child:
                                Text('선호도 조사 다시하기', style: contentsTextStyle),
                            onPressed: () {},
                          )
                        : ElevatedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: whiteBorder,
                                padding: const EdgeInsets.all(12)),
                            child: Text('팔로우하기', style: contentsTextStyle)))
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
              crossAxisSpacing: 3,
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titleBar('$realname와 취향이 비슷한 사용자'),
          Container(
              width: width,
              decoration: outerBorder,
              height: boxHeight,
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserPage(
                                  isMyPage: false,
                                  otherUser: userList[index],
                                )),
                      );
                    },
                    child: userCoverCard(userList[index]),
                  );
                },
              )),
          defaultSpacer,
        ]);
  }

  Widget userAnalyze() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBar('$realname님의 취향분석 결과'),
        Container(
            decoration: outerBorder,
            width: width,
            height: 590,
            child: Center(
                child: Text(
              '취향분석 결과',
              style: titleTextStyle,
            )))
      ],
    );
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
                    widget.isMyPage
                        ?
                        // 나와 비슷한 유저 추천
                        userRecommendation()
                        : defaultSpacer,
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
