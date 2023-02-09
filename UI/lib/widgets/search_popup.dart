import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:ui/models/item.dart';
import 'package:ui/utils/dio_client.dart';
import 'package:ui/widgets/custom_card.dart';
import 'package:ui/widgets/track_detail.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class Track {}

class _SearchBarState extends State<SearchBar> {
  List<searchItem> tracks = [];
  DioClient dioClient = DioClient();

  void getSearchTracks(String track) async {
    var res = await dioClient.getSearchTrack(track: track);
    for (var r in res) {
      tracks.add(searchItem(
          trackId: r['track_id'] as int,
          trackName: r['track_name'] as String,
          artistName: r['artist_name'] as String));
    }
    setState(() {});
  }

  @override
  void initState() {
    getSearchTracks('-1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        body: Center(
            child: Stack(alignment: Alignment.topRight, children: [
          Container(
            height: 500,
            width: 500,
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: kWhite),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('검색', style: titleTextStyle),
                defaultSpacer,
                Expanded(
                  //   height: 400,
                  //   padding: const EdgeInsets.all(12),
                  child: SearchableList<searchItem>(
                    style: contentsTextStyle,
                    cursorColor: kWhite,
                    initialList: tracks,
                    onSubmitSearch: (search) {
                      getSearchTracks(search!);
                    },
                    asyncListCallback: () async {
                      await Future.delayed(
                        const Duration(
                          milliseconds: 1000,
                        ),
                      );
                      return tracks;
                    },
                    asyncListFilter: (q, list) {
                      return list
                          .where((element) => element.trackName.contains(q))
                          .toList();
                    },
                    onRefresh: () async {},
                    builder: (searchItem track) => searchCard(track),
                    onItemSelected: (searchItem item) async {
                      // get track Item
                      var track = await dioClient.getTrackDetail(item.trackId);
                      String albumName = '';
                      if (track['album_name'] == null) {
                        albumName = track['track_name'];
                      }
                      int albumImageNum = Random().nextInt(4);
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) => DetailPage(
                                  item: Item(
                                      trackId: track['track_id'] as int,
                                      trackName: track['track_name'],
                                      image: 'assets/album$albumImageNum.png',
                                      artistName: track['artist_name'],
                                      albumName: albumName,
                                      duration: track['duration'] as int,
                                      url: track['url']),
                                )),
                      );
                    },
                    emptyWidget: Text(
                      '일치하는 노래가 없습니다.',
                      style: subtitleTextStyle,
                    ),
                    inputDecoration: InputDecoration(
                      focusColor: kWhite,
                      labelText: "검색하기",
                      labelStyle: defaultTextStyle,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kWhite,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kWhite,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: kWhite)),
        ])));
  }
}
