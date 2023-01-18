import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

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
    color: kDarkGrey,
    child: SizedBox(
      height: 30,
      width: 80,
      child: Center(
          child: Text(
        '$idx',
        textAlign: TextAlign.center,
      )),
    ),
  );
}

Widget artistCard() {
  String image = 'profile.png';
  String name = '아티스트명';
  return Container(
      width: 180,
      padding: EdgeInsets.all(15),
      child: Column(children: [
        SizedBox(
          height: 130,
          width: 130,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(image),
          ),
        ),
        defaultSpacer,
        Text(name, style: contentsTextStyle, textAlign: TextAlign.start),
      ]));
}

Widget userCard() {
  String image = 'profile.png';
  String name = '홍길동';
  int follower = 300;
  bool isFollowing = false;

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
        isFollowing
            ? Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: whiteBorder,
                      ),
                      child: Text('팔로잉',
                          style: defaultTextStyle, textAlign: TextAlign.center))
                ],
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: whiteBorder,
                      ),
                      child: Text('팔로우',
                          style: defaultTextStyle, textAlign: TextAlign.center))
                ],
              ),
      ],
    ),
  );
}

Widget playlistCard() {
  String albumimage = 'album.png';
  String trackname = 'Track Name';
  String artistname = 'Artist Name';
  String release = '2022.01.17';

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
            albumimage,
            fit: BoxFit.cover,
          ),
        ),
        defaultSpacer,
        // track name
        Text(trackname, style: subtitleTextStyle, textAlign: TextAlign.start),
        // artist name
        Text(artistname, style: contentsTextStyle, textAlign: TextAlign.start),
        // 발매일
        Text(release, style: contentsTextStyle, textAlign: TextAlign.start),
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
        defaultSpacer,
        // 재생시간e
        Text('3:44', style: defaultTextStyle, textAlign: TextAlign.start),
        const Spacer(),
        TextButton(
            onPressed: () {}, child: Icon(Icons.favorite_outline_rounded))
      ],
    ),
  );
}
