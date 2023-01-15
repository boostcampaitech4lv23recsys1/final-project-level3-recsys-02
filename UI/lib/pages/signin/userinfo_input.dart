import 'package:flutter/material.dart';
import 'package:ui/constants.dart';

class UserInfoInput extends StatefulWidget {
  const UserInfoInput({super.key});

  @override
  _UserInfoInputState createState() => _UserInfoInputState();
}

class _UserInfoInputState extends State<UserInfoInput> {
  @override
  Widget build(BuildContext context) {
    Widget inputTemplate(String title, String hint) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: subtitleTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            height: titleHeight,
            decoration: outerBorder,
            child: Text(
              hint,
              style: TextStyle(color: kDarkGrey),
            ),
          ),
          defaultSpacer
        ],
      );
    }

    return SizedBox(
        height: 580,
        width: MediaQuery.of(context).size.width,
        // decoration: outerBorder,
        child: ListView(
          children: [
            inputTemplate('이메일이 어떻게 되시나요?', '이메일을 입력하세요.'),
            inputTemplate('이메일을 확인하세요.', '이메일을 다시 입력하세요.'),
            inputTemplate('비밀번호를 만드세요.', '비밀번호를 만드세요.'),
            inputTemplate('어떤 사용자 이름을 사용하시겠어요?', '프로필 이름을 입력하세요.'),
            inputTemplate('생년월일이 어떻게 되시나요?', '(예시) 199910108'),
            inputTemplate(
                '성별이 무엇인가요? (1: 남성,  2: 여성, 3: 기타, 4: 답변거부', '(예시) 2'),
          ],
        ));
  }
}
