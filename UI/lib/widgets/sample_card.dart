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

Widget userCard() {
  return Card(
    elevation: 0,
    color: kDarkGrey,
    child: SizedBox(
      width: 200,
      child: const Center(child: Text('Filled Card')),
    ),
  );
}

Widget playlistCard() {
  return Card(
    elevation: 0,
    color: kDarkGrey,
    child: SizedBox(
      width: 200,
      child: const Center(child: Text('Filled Card')),
    ),
  );
}

Widget chartCard({w, h}) {
  return Card(
    elevation: 0,
    color: kDarkGrey,
    child: SizedBox(
      height: buttonHeight,
      child: const Center(child: Text('Filled Card')),
    ),
  );
}
