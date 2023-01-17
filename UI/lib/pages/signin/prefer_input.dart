import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/widgets/footer.dart';
import 'package:ui/widgets/sample_card.dart';
import 'package:ui/widgets/signin_header.dart';

class PrefernceInput extends StatefulWidget {
  const PrefernceInput({super.key});

  @override
  _PrefernceInputState createState() => _PrefernceInputState();
}

class _PrefernceInputState extends State<PrefernceInput> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Expanded(
        // height: 580,
        // width: MediaQuery.of(context).size.width,
        // decoration: outerBorder,
        child: ListView(
      children: [
        Text('선호하시는 분위기 및 장르 5개를 선택해주세요', style: subtitleTextStyle),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: outerBorder,
            height: boxHeight - 20,
            child: GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 0.2,
              children: [
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
                genreCard(0),
              ],
            )),
        defaultSpacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('선호하시는 아티스트 5명을 선택해주세요', style: subtitleTextStyle),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: kWhite))
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            decoration: outerBorder,
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return artistCard();
              },
            )),
      ],
    ));
  }
}
