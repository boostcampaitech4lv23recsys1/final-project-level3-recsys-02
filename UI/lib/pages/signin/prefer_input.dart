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
    return SizedBox(
        height: 580,
        width: MediaQuery.of(context).size.width,
        // decoration: outerBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('선호하시는 장르 5개를 선택해주세요', style: subtitleTextStyle),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: outerBorder,
              height: 200,
            ),
            Text('선호하시는 아티스트 5명을 선택해주세요', style: subtitleTextStyle),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: outerBorder,
                height: 215,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return userCard(isArtist: true);
                  },
                )),
            Text('선호하시는 노래 5개를  선택해주세요', style: subtitleTextStyle),
            Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: outerBorder,
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return playlistCard();
                  },
                )),
          ],
        ));

    // Scaffold(
    //     body: Padding(
    //         padding: const EdgeInsets.all(60),
    //         child: Column(children: [
    //           signinHeader(context),
    //           defaultSpacer,
    //           Container(
    //             decoration: outerBorder,
    //             height: 700,
    //             child: SingleChildScrollView(
    //               physics: const NeverScrollableScrollPhysics(),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   // 개인정보
    //                   Container(
    //                       padding: defaultPadding,
    //                       height: 300,
    //                       alignment: Alignment.topLeft,
    //                       width: width,
    //                       decoration: outerBorder,
    //                       child: Column(
    //                           children: [divider('STEP 0', '개인정보를 입력해주세요')])),
    //                   // 장르
    //                   Container(
    //                       padding: defaultPadding,
    //                       alignment: Alignment.topLeft,
    //                       width: width,
    //                       height: 250,
    //                       decoration: outerBorder,
    //                       child: Column(children: [
    //                         divider('STEP 1', '선호하는 장르 5개를 선택해주세요'),
    //                         defaultSpacer,
    //                         Container(
    //                             decoration: outerBorder,
    //                             height: 180,
    //                             width: width,
    //                             child: ListView.builder(
    //                               scrollDirection: Axis.horizontal,
    //                               physics: const NeverScrollableScrollPhysics(),
    //                               itemCount: 20,
    //                               itemBuilder:
    //                                   (BuildContext context, int index) {
    //                                 return sampleCard();
    //                               },
    //                             ))
    //                       ])),
    //                   // 아티스트
    //                   Container(
    //                       padding: defaultPadding,
    //                       alignment: Alignment.topLeft,
    //                       width: width,
    //                       height: 250,
    //                       decoration: outerBorder,
    //                       child: Column(children: [
    //                         divider('STEP 2', '좋아하는 아티스트 5명을 선택해주세요'),
    //                         defaultSpacer,
    //                         Container(
    //                             decoration: outerBorder,
    //                             height: 180,
    //                             width: width,
    //                             child: ListView.builder(
    //                               scrollDirection: Axis.horizontal,
    //                               physics: const NeverScrollableScrollPhysics(),
    //                               itemCount: 20,
    //                               itemBuilder:
    //                                   (BuildContext context, int index) {
    //                                 return sampleCard();
    //                               },
    //                             ))
    //                       ])),
    //                   // 음원
    //                   Container(
    //                       padding: defaultPadding,
    //                       alignment: Alignment.topLeft,
    //                       width: width,
    //                       height: 250,
    //                       decoration: outerBorder,
    //                       child: Column(children: [
    //                         divider('STEP 1', '선호하는 음원 5개를 선택해주세요'),
    //                         defaultSpacer,
    //                         Container(
    //                             decoration: outerBorder,
    //                             height: 180,
    //                             width: width,
    //                             child: ListView.builder(
    //                               scrollDirection: Axis.horizontal,
    //                               physics: const NeverScrollableScrollPhysics(),
    //                               itemCount: 20,
    //                               itemBuilder:
    //                                   (BuildContext context, int index) {
    //                                 return sampleCard();
    //                               },
    //                             ))
    //                       ])),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           const Spacer(),
    //           footer()
    //         ])));
  }
}
