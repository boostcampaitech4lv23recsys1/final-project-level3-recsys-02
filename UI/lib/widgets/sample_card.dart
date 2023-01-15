import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

Widget sampleCard() {
  return Card(
    elevation: 0,
    color: kDarkGrey,
    child: SizedBox(
      width: 150,
      child: const Center(child: Text('Filled Card')),
    ),
  );
}

Widget userCard({bool isArtist = false}) {
  String image = 'image.jpg';
  String name = '홍길동';
  int follower = 3333;

  return Container(
    width: 180,
    padding: kPadding,
    child: Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(image),
          ),
        ),
        defaultSpacer,
        Text(name, style: contentsTextStyle, textAlign: TextAlign.start),
        isArtist
            ? Container()
            : Text('팔로워 $follower 명',
                style: defaultTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget playlistCard() {
  String albumimage = 'album.jpg';
  String trackname = 'OMG';
  String artistname = 'New Jeans';

  return Container(
    //decoration: outerBorder,
    width: 180,
    padding: kPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image
        ClipRRect(
          borderRadius: kBorder,
          child: Image.asset(
            albumimage,
            fit: BoxFit.cover,
          ),
        ),
        defaultSpacer,
        // track name
        Text(trackname, style: subtitleTextStyle, textAlign: TextAlign.start),
        // artist name
        Text(artistname, style: contentsTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget chartCard(int rank) {
  String albumimage = 'album.jpg';
  String trackname = 'OMG';
  String artistname = 'New Jeans';

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

        // track name
        Text(trackname, style: contentsTextStyle, textAlign: TextAlign.start),
        Spacer(),
        // artist name
        Text(artistname, style: defaultTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}
