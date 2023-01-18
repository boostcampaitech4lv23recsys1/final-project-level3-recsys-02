import 'package:flutter/material.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/item.dart';
import 'package:ui/widgets/custom_card.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.item});
  final Item item;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String _image, _albumName, _artistName;
  void getAlbum(Item item) {}
  @override
  void initState() {
    super.initState();
    _image = widget.item.image;
    _albumName = widget.item.name;
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
            height: 700,
            width: 500,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              defaultSpacer,
              defaultSpacer,
              Container(
                  height: 200,
                  width: 500,
                  child: Image.asset(
                    _image,
                    fit: BoxFit.cover,
                  )),
              defaultSpacer,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  defaultSpacer,
                  Text(_albumName, style: titleTextStyle),
                  const Spacer(),
                  Text(_artistName, style: contentsTextStyle),
                  defaultSpacer
                ],
              ),
              defaultSpacer,
              Container(
                  width: 500,
                  height: 360,
                  child: ListView.builder(
                    padding: defaultPadding,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: chartCard(index + 1),
                      );
                    },
                  ))
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
