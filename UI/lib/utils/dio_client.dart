import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/constants.dart';
import 'package:ui/models/user.dart';
import 'package:ui/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
    ),
  )..interceptors.add(Logging());

  Future loginUser({required String name, required String pwd}) async {
    late Response response;
    try {
      Map<String, String> userData = {'name': name, 'pwd': pwd};
      response = await _dio.post('/users/login', data: userData);
      debugPrint(response.toString());

      if ('fail' != response.data['result']) {
        return 'fail';
      } else {
        // user_name만 전역적으로 저장
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user_name', response.data['result']);
        return 'success';
      }
    } catch (e) {
      debugPrint('Error login : $e');
    }
  }

  Future signinUser({required UserInfo userInfo}) async {
    late Response response;
    try {
      response = await _dio.post('/users/signin', data: userInfo.toJson());
      debugPrint(response.toString());
      return response;
    } catch (e) {
      debugPrint('Error signin: $e');
      return 'fail';
    }
  }
}
