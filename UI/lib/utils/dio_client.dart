import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/models/user.dart';
import 'package:ui/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8001',
      validateStatus: (_) => true,
      responseType: ResponseType.json,
    ),
  )..interceptors.add(Logging());

  Future loginUser({required String name, required String pwd}) async {
    late Response response;

    try {
      var userData = {"id": name, "pwd": pwd};
      response = await _dio.post('/login', data: userData);
      debugPrint('dioclient: ${response.data}');

      if (response.data == 'empty') {
        return 'empty';
      } else if (response.data == 'Internal Server Error') {
        return 'fail';
      } else {
        // user_name만 전역적으로 저장
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user_name', response.data);
        return 'success';
      }
    } catch (e) {
      debugPrint('Error login : $e');
    }
  }

  Future signinUser(
      {required UserInfo userInfo,
      required List<String> tags,
      required List<String> artists}) async {
    late Response response;

    try {
      var datas = {
        "userInfo": userInfo.toJson(),
        "tags": tags,
        "artists": artists
      };
      debugPrint(datas.toString());

      response = await _dio.post('/signin', data: datas);
      debugPrint('dioclient: $response');
      if (response.data == 'exist') {
        return 'exist';
      } else {
        return response.data['user_name'];
      }
    } catch (e) {
      debugPrint('Error signin: $e');
      return 'fail';
    }
  }
}
