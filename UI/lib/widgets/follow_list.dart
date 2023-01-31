import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/models/user.dart';
import 'package:ui/widgets/custom_card.dart';

class FollowListPage extends StatefulWidget {
  const FollowListPage(
      {super.key, required this.itemList, required this.isFollowing});
  final List<String> itemList;
  final bool isFollowing;

  @override
  _FollowListPageState createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  void getAlbum(Item item) {}
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          itemCount: widget.itemList.length,
                          itemBuilder: (context, index) {
                            return userCard(OtherUser(
                                name: '이름', followerNum: 5, isFollowing: true));
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
