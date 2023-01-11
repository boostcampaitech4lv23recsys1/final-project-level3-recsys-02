import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/home_header.dart';
import 'package:ui/widgets/sample_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    Widget titleBar(String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          defaultSpacer,
          Text(
            title,
            style: const TextStyle(
                fontSize: titleFontSize, fontWeight: FontWeight.bold),
          ),
          IconButton(icon: const Icon(Icons.repeat), onPressed: () {}),
        ],
      );
    }

    return SafeArea(
        minimum: const EdgeInsets.all(60),
        child: Scaffold(
            body: Column(children: [
          homeHeader(context),
          defaultSpacer,
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            // 개인화된 플레이리스트 추천
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  decoration: outerBorder,
                  width: _width * 0.6,
                  child: titleBar('개인화된 플레이리스트')),
              Container(
                  decoration: outerBorder,
                  height: 280,
                  width: _width * 0.6,
                  child: ListView.builder(
                    padding: defaultPadding,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return playlistCard();
                    },
                  )),
            ]),
            const Spacer(),
            // 기본차트
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  decoration: outerBorder,
                  width: _width * 0.3,
                  child: titleBar('기본차트')),
              Container(
                  decoration: outerBorder,
                  width: _width * 0.3,
                  height: 280,
                  child: ListView.builder(
                    padding: defaultPadding,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: chartCard(),
                      );
                    },
                  ))
            ]),
          ]),
          defaultSpacer,
          // 비슷한 유저 추천
          Column(
            children: [
              Container(
                  decoration: outerBorder,
                  width: _width,
                  child: titleBar('비슷한 유저 추천')),
              Container(
                  decoration: outerBorder,
                  width: _width,
                  height: 280,
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
            ],
          ),
          const Spacer(),
          footer()
        ])));
  }
}
