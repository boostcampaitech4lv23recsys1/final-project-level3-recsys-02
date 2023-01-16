import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/sample_card.dart';
import 'package:ui/widgets/titlebar.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  get follower => 5;
  get following => 5;
  get match => 98;
  var name = '고비';
  bool isMyPage = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(children: [
              customHeader(context, '메인페이지'),
              defaultSpacer,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      titleBar(width * 0.3, '내 정보', withArrow: false),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: outerBorder,
                          height: boxHeight,
                          width: width * 0.3,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: profileBorder,
                                  height: 200,
                                  width: 200,
                                  child: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/profile.png'),
                                  ),
                                ),
                                defaultSpacer,
                                defaultSpacer,
                                Stack(
                                  alignment: AlignmentDirectional.bottomStart,
                                  children: [
                                    SizedBox(
                                      // decoration: outerBorder,
                                      width: width * 0.12,
                                      height: 180,
                                      child: GridView.count(
                                          crossAxisCount:
                                              2, //1 개의 행에 보여줄 item 개수
                                          childAspectRatio: (1 / 0.3),
                                          crossAxisSpacing: 10,
                                          children: [
                                            Text('$name 님',
                                                style: titleTextStyle),
                                            const Text(''),
                                            Text('♥ 팔로잉',
                                                style: contentsTextStyle),
                                            Text(
                                              '$following 명',
                                              style: contentsTextStyle,
                                              textAlign: TextAlign.end,
                                            ),
                                            Text('♥ 팔로워',
                                                style: contentsTextStyle),
                                            Text(
                                              '$follower 명',
                                              style: contentsTextStyle,
                                              textAlign: TextAlign.end,
                                            ),
                                            Text('♥ 취향매칭률',
                                                style: contentsTextStyle),
                                            Text(
                                              '$match %',
                                              style: contentsTextStyle,
                                              textAlign: TextAlign.end,
                                            ),
                                          ]),
                                    ),
                                    Container(
                                        height: titleHeight * 0.8,
                                        width: buttonWidth * 2,
                                        child: ElevatedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            side: whiteBorder,
                                          ),
                                          child: Text('팔로우',
                                              style: contentsTextStyle),
                                          onPressed: () {},
                                        )),
                                  ],
                                ),
                              ])),
                      defaultSpacer,
                      titleBar(width * 0.3, '나의 재생목록'),
                      Container(
                          decoration: outerBorder,
                          width: width * 0.3,
                          height: boxHeight,
                          child: ListView.builder(
                            padding: defaultPadding,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return playlistCard();
                            },
                          )),
                    ],
                  ),
                  const Spacer(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleBar(width * 0.6, '$name님의 취향분석 결과',
                            withArrow: false),
                        Container(
                            decoration: outerBorder,
                            width: width * 0.6,
                            height: 625,
                            child: Center(
                                child: Text(
                              '취향분석 결과',
                              style: titleTextStyle,
                            )))
                      ]),
                ],
              ),
              const Spacer(),
              footer()
            ])));
  }
}
