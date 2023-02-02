import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/models/user.dart';
import 'package:ui/pages/user_page.dart';
import 'package:ui/utils/dio_client.dart';
import 'package:ui/widgets/custom_card.dart';

class FollowListPage extends StatefulWidget {
  const FollowListPage(
      {super.key, required this.itemNameList, required this.isFollowing});
  final List<String> itemNameList;
  final bool isFollowing;

  @override
  _FollowListPageState createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  final DioClient dio = DioClient();

  late List<OtherUser> itemList = [];

  void getAlbum(Item item) {}
  void getItemProfile() async {
    // for (int i = 0; i < widget.itemNameList.length; i++) {
    // Map value = await dio.profile(name: widget.itemNameList[i]);
    // // get itemLNameList Profiles
    // itemList.add(OtherUser(
    //     user_name: value['user_id'] as int,
    //     realname: value['realname'] as String,
    //     image: value['image'] as String,
    //     following: List<String>.from(value['following']),
    //     follower: List<String>.from(value['follower'])));
    for (int i = 0; i < 10; i++) {
      itemList.add(OtherUser(
          user_id: i,
          realname: 'user$i',
          image: 'assets/profile.png',
          following: [],
          follower: []));
    }
    setState(() {});
  }

  @override
  void initState() {
    getItemProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('other user list ${itemList.toList()}');
    return Scaffold(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        body: Center(
            child: Stack(alignment: Alignment.topRight, children: [
          Container(
            height: 500,
            width: 500,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isFollowing
                      ? Text(
                          '팔로잉',
                          style: titleTextStyle,
                        )
                      : Text(
                          '팔로워',
                          style: titleTextStyle,
                        ),
                  defaultSpacer,
                  Container(
                      decoration: outerBorder,
                      height: 300,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: itemList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserPage(
                                              isMyPage: false,
                                              otherUser: itemList[index],
                                            )),
                                  );
                                },
                                child: userCard(
                                  OtherUser(
                                    user_id: itemList[index].user_id,
                                    realname: itemList[index].realname,
                                    image: itemList[index].image,
                                    following: itemList[index].following,
                                    follower: itemList[index].follower,
                                  ),
                                ));
                          }))
                ]),
          ),
          Positioned(
            top: 10,
            right: 30,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: kWhite)),
          )
        ])));
  }
}
