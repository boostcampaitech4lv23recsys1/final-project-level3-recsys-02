import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';

Widget sampleCard() {
  return Card(
    elevation: 0,
    color: kDarkGrey,
    child: const SizedBox(
      height: 180,
      width: 150,
      child: Center(child: Text('Filled Card')),
    ),
  );
}

Widget genreCard(idx) {
  return Card(
    elevation: 0,
    child: Container(
      color: Colors.transparent,
      height: titleHeight,
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        '${idx[0]}',
        style: contentsTextStyle,
      ),
    ),
  );
}

Widget artistCard() {
  String image = 'profile.png';
  String name = '아티스트명';
  return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      child: Column(children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(image),
          ),
        ),
        defaultSpacer,
        Text(name, style: contentsTextStyle, textAlign: TextAlign.start),
      ]));
}

Widget userCard(image, name, follower) {
  String image = 'profile.png';

  return Container(
    width: 160,
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(image),
          ),
        ),
        defaultSpacer,
        Text(name, style: contentsTextStyle, textAlign: TextAlign.start),
        Text('팔로워 $follower 명',
            style: defaultTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget playlistCard(Item item) {
  return Container(
      //decoration: outerBorder,
      width: 170,
      padding: kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: kBorder,
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
          defaultSpacer,
          // track name
          Text(item.name, style: subtitleTextStyle, textAlign: TextAlign.start),
          // artist name
          Text(item.artistName,
              style: contentsTextStyle, textAlign: TextAlign.start),
        ],
      ));
}

Widget albumCard(Item item) {
  return Container(
    //decoration: outerBorder,
    width: 170,
    padding: kPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image
        ClipRRect(
          borderRadius: kBorder,
          child: Image.asset(
            item.image,
            fit: BoxFit.cover,
          ),
        ),
        defaultSpacer,
        // track name
        Text(item.name, style: subtitleTextStyle, textAlign: TextAlign.start),
        // artist name
        Text(item.artistName,
            style: contentsTextStyle, textAlign: TextAlign.start),
        // 발매일
        Text(item.release,
            style: contentsTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget chartCard(int rank) {
  String albumimage = 'album.png';
  String trackname = 'Track Name';
  String artistname = 'Artist Name';

  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$rank',
          style: subtitleTextStyle,
        ),
        defaultSpacer,
        // image
        ClipRect(
          child: Image.asset(albumimage),
        ),
        defaultSpacer,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // track name
            Text(
              trackname,
              style: contentsTextStyle,
              textAlign: TextAlign.start,
            ),
            Text(artistname,
                style: defaultTextStyle, textAlign: TextAlign.start),
          ],
        ),
        const Spacer(),

        // 재생시간e
        Text('3:44', style: defaultTextStyle, textAlign: TextAlign.start),
        defaultSpacer
      ],
    ),
  );
}
