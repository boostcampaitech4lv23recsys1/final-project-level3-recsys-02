import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/custom_header.dart';
import 'package:ui/widgets/sample_card.dart';
import 'package:ui/widgets/titlebar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Padding(
            padding: outerPadding,
            child: Column(children: [
              customHeader(context, '마이페이지'),
              defaultSpacer,
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                // 빠른 선곡
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.5, '빠른 선곡'),
                  Container(
                      decoration: outerBorder,
                      height: boxHeight,
                      width: width * 0.5,
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
                ]),
                const Spacer(),
                // 인기곡
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.4, '인기곡', withReset: false),
                  Container(
                      decoration: outerBorder,
                      width: width * 0.4,
                      height: boxHeight,
                      child: ListView.builder(
                        padding: defaultPadding,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: chartCard(index + 1),
                          );
                        },
                      ))
                ]),
              ]),
              defaultSpacer,
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                // 최신앨범
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.5, '최신 음악', withReset: false),
                  Container(
                      decoration: outerBorder,
                      width: width * 0.5,
                      height: boxHeight,
                      child: ListView.builder(
                        padding: defaultPadding,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: playlistCard(),
                          );
                        },
                      ))
                ]),
                const Spacer(),
                // 비슷한 유저 추천
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.4, '취향이 비슷한 친구 찾기'),
                  Container(
                      decoration: outerBorder,
                      height: boxHeight,
                      width: width * 0.4,
                      child: ListView.builder(
                        padding: defaultPadding,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return userCard();
                        },
                      )),
                ]),
              ]),
              const Spacer(),
              footer()
            ])));
  }
}
