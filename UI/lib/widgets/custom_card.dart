import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/models/user.dart';

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

Widget signinItemCard(item) {
  return Container(
    color: Colors.transparent,
    height: titleHeight,
    width: 100,
    padding: EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.centerLeft,
    child: Text(
      '${item[0]}',
      style: contentsTextStyle,
    ),
  );
}

Widget userCoverCard(image, name, follower) {
  String image = 'assets/profile.png';

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
        SizedBox(
          height: 10,
        ),
        Text(name, style: contentsTextStyle, textAlign: TextAlign.start),
        Text('팔로워 $follower 명',
            style: defaultTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget userCard(OtherUser otherUser) {
  String image = 'assets/profile.png';

  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image
        ClipRect(
          child: Image.asset(image),
        ),
        defaultSpacer,
        defaultSpacer,
        Text(
          otherUser.name,
          style: contentsTextStyle,
          textAlign: TextAlign.start,
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: otherUser.isFollowing
              ? Text(
                  '팔로잉',
                  style: contentsTextStyle,
                  textAlign: TextAlign.start,
                )
              : Text(
                  '팔로우',
                  style: contentsTextStyle,
                  textAlign: TextAlign.start,
                ),
        )
      ],
    ),
  );
}

Widget trackCoverCard(Item item) {
  return Container(
    //decoration: outerBorder,
    width: 150,
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
        SizedBox(
          height: 20,
        ),
        // track name
        Text(item.trackName,
            style: subtitleTextStyle, textAlign: TextAlign.start),
        SizedBox(
          height: 10,
        ),
        // artist name
        Text(item.artistName,
            style: contentsTextStyle, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget trackCard(Item item, {bool isRank = false, int index = 1}) {
  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image
        ClipRect(
          child: Image.asset(
            item.image,
          ),
        ),
        defaultSpacer,
        isRank
            ? Text(
                '$index',
                style: subtitleTextStyle,
              )
            : Text(''),
        defaultSpacer,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // track name
            Text(
              item.trackName,
              style: contentsTextStyle,
              textAlign: TextAlign.start,
            ),
            Text(item.artistName,
                style: defaultTextStyle, textAlign: TextAlign.start),
          ],
        ),
        const Spacer(),

        // 재생시간e
        Text(duration2String(item.duration),
            style: defaultTextStyle, textAlign: TextAlign.start),
        defaultSpacer
      ],
    ),
  );
}

Widget playlistCard(Item item) {
  bool isLike = true;
  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image
        ClipRect(
          child: Image.network(
            item.image,
          ),
        ),
        defaultSpacer,
        Expanded(
          child: Text(
            overflow: TextOverflow.fade,
            softWrap: true,
            item.trackName,
            style: contentsTextStyle,
            textAlign: TextAlign.start,
          ),
        ),
        // 재생시간e
        Text(duration2String(item.duration),
            style: defaultTextStyle, textAlign: TextAlign.start),
        defaultSpacer,

        // 좋아요
        IconButton(
            onPressed: () {
              if (isLike) {
                isLike = false;
              } else {
                isLike = true;
              }
            },
            icon: isLike
                ? Icon(
                    Icons.favorite,
                    color: kWhite,
                  )
                : Icon(
                    Icons.favorite_outline_rounded,
                    color: kWhite,
                  )),
      ],
    ),
  );
}
