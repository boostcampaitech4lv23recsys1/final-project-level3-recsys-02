import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.item});
  final Item item;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String _image, _name, _albumName, _artistName;
  var isLike = false;
  var url = 'https://www.naver.com';

  void getAlbum(Item item) {}
  @override
  void initState() {
    super.initState();
    _image = widget.item.image;
    _name = widget.item.name;
    _albumName = widget.item.albumName;
    _artistName = widget.item.artistName;
    getAlbum(widget.item);
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
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  defaultSpacer,
                  defaultSpacer,
                  Container(
                      height: 200,
                      width: 500,
                      child: Image.network(
                        _image,
                        fit: BoxFit.cover,
                      )),
                  defaultSpacer,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      defaultSpacer,
                      Text(_name, style: titleTextStyle),
                      const Spacer(),

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
                      defaultSpacer
                    ],
                  ),
                  Container(
                      decoration: outerBorder,
                      height: 150,
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('앨범 명', style: contentsTextStyle),
                              Text('$_albumName', style: contentsTextStyle),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('아티스트 명', style: contentsTextStyle),
                              Text('$_artistName', style: contentsTextStyle),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('URL', style: contentsTextStyle),
                              Text('$url', style: contentsTextStyle),
                            ],
                          )
                        ],
                      )),
                ]),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: kWhite)),
        ])));
  }
}
