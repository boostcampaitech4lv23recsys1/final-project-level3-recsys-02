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
            padding: const EdgeInsets.all(60),
            child: Column(children: [
              customHeader(context, '마이페이지'),
              defaultSpacer,
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                // 빠른 선곡
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.6, '빠른 선곡'),
                  Container(
                      decoration: outerBorder,
                      height: 260,
                      width: width * 0.6,
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
                // 최신차트
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.3, '최신차트', withArrow: false),
                  Container(
                      decoration: outerBorder,
                      width: width * 0.3,
                      height: 260,
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.6, '취향이 비슷한 친구 찾기'),
                  Container(
                      decoration: outerBorder,
                      height: boxHeight,
                      width: width * 0.6,
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
                const Spacer(),
                // 기본차트
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  titleBar(width * 0.3, '기본차트', withArrow: false),
                  Container(
                      decoration: outerBorder,
                      width: width * 0.3,
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
              const Spacer(),
              footer()
            ])));
  }
}
