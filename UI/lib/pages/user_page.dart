import 'package:flutter/material.dart';
import 'package:ui/widgets/signin_header.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        signinHeader(context),
      ],
    ));
  }
}
