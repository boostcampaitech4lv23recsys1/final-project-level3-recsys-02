import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/models/user.dart';
import 'package:ui/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://0.0.0.0:8001',
    ),
  )..interceptors.add(Logging());

  Future<void> setProfile(data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('id', data['id']);
    await pref.setString('name', data['name']);
    await pref.setString('country', data['country']);

    await pref.setBool('open', data['open']);

    await pref.setInt('image', data['image']);
    await pref.setInt('age', data['age']);
    await pref.setInt('gender', data['gender']);

    await pref.setStringList('followers', data['followers'].cast<String>());
    await pref.setStringList('following', data['followers'].cast<String>());
  }

  Future loginUser({required String email, required String pwd}) async {
    late Response response;
    try {
      Map<String, String> userData = {'id': email, 'pwd': pwd};
      response = await _dio.post('/users/login', data: userData);
      debugPrint(response.toString());
      await setProfile(response.data);
      return response.statusCode;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }

  Future signinUser({required UserInfo userInfo}) async {
    late Response response;
    try {
      response = await _dio.post('/users/signin', data: userInfo.toJson());
      debugPrint(response.toString());
      return response.statusCode;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }

  // 좋아요 리스트 불러오기
  Future likesList({required String name}) async {
    late Response response;
    try {
      response = await _dio.get('/users/' + name + '/likes');
      debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }

  // 프로필 불러오기
  Future profile({required String name}) async {
    late Response response;
    try {
      response = await _dio.get('/users/' + name + '/profiles');
      debugPrint(response.toString());
      Map responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }
}
