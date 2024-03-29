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
    width: 150,
    padding: EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.centerLeft,
    child: Text(
      '${item[0]}',
      style: contentsTextStyle,
    ),
  );
}

Widget userCoverCard(OtherUser other) {
  return Container(
    width: 180,
    height: 200,
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        SizedBox(
          height: 170,
          width: 170,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(other.image),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(other.realname,
            style: contentsTextStyle3, textAlign: TextAlign.start),
        SizedBox(
          height: 5,
        ),
        Text('팔로워 ${other.follower.length} 명',
            style: defaultTextStyle4, textAlign: TextAlign.start),
      ],
    ),
  );
}

Widget userCard(OtherUser otherUser) {
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
          child: Image.network(otherUser.image),
        ),
        defaultSpacer,
        defaultSpacer,
        Text(
          otherUser.realname,
          style: contentsTextStyle,
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}

Widget trackCoverCard(Item item) {
  return Container(
    //decoration: outerBorder,
    height: boxHeight,
    width: 240,
    padding: kPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image
        SizedBox(
          height: 240,
          width: 240,
          child: ClipRRect(
            borderRadius: kBorder,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        // track name
        SizedBox(
          width: 240,
          child: Text(item.trackName,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: ssubtitleTextStyle,
              textAlign: TextAlign.start),
        ),
        SizedBox(
          height: 2,
        ),
        // artist name
        SizedBox(
          width: 240,
          child: Text(item.artistName,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: ccontentsTextStyle,
              textAlign: TextAlign.start),
        ),
      ],
    ),
  );
}

Widget searchCard(searchItem item) {
  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // track name
        Expanded(
          child: Text(
            item.trackName,
            style: contentsTextStyle,
            textAlign: TextAlign.start,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
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
    width: titleHeight * (1.5),
    //padding: kPadding2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image
        SizedBox(
          height: 65,
          width: 65,
          child: ClipRRect(
            //borderRadius: kBorder,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        defaultSpacer2,
        isRank
            ? Text(
                '$index',
                style: subtitleTextStyle,
              )
            : Text(''),
        defaultSpacer2,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // track name
            Container(
              width: 230,
              child: Text(
                overflow: TextOverflow.fade,
                softWrap: true,
                item.trackName,
                maxLines: 2,
                style: contentsTextStyle2,
                textAlign: TextAlign.start,
              ),
            ),
            Text(item.artistName,
                overflow: TextOverflow.fade,
                softWrap: true,
                style: defaultTextStyle2,
                textAlign: TextAlign.start),
          ],
        ),
        const Spacer(),

        // 재생시간e
        Text(duration2String(item.duration),
            style: defaultTextStyle3, textAlign: TextAlign.start),
        defaultSpacer
      ],
    ),
  );
}

Widget playlistCard(Item item, {isLike = false}) {
  return Container(
    // decoration: outerBorder,
    height: titleHeight * (1.5),
    //padding: kPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // image
        SizedBox(
          height: 55,
          width: 55,
          child: ClipRRect(
            //borderRadius: kBorder,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        defaultSpacer2,
        // isRank
        //     ? Text(
        //         '1',
        //         style: subtitleTextStyle,
        //       )
        //     : Text(''),
        //defaultSpacer2,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // track name
            Container(
              width: 200,
              child: Text(
                overflow: TextOverflow.fade,
                softWrap: true,
                item.trackName,
                maxLines: 2,
                style: contentsTextStyle4,
                textAlign: TextAlign.start,
              ),
            ),
            Text(item.artistName,
                overflow: TextOverflow.fade,
                softWrap: true,
                style: defaultTextStyle3,
                textAlign: TextAlign.start),
          ],
        ),
        //const Spacer(),
        //defaultSpacer3,
        // 좋아요
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite,
              color: kWhite,
            )),
      ],
    ),
  );
}
