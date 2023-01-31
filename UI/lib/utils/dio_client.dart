import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/models/user.dart';
import 'package:ui/models/item.dart';
import 'package:ui/models/ops.dart';
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

      if (response.data == 'Empty') {
        return 'Empty';
      } else if (response.data == 'Internal Server Error') {
        return 'Error';
      } else {
        // user_name만 전역적으로 저장
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user_name', response.data);
        return 'Success';
      }
    } catch (e) {
      debugPrint('Error login : $e');
    }
  }

  Future getArtists() async {
    Response response = await _dio.get('/signin/artists');
    return response.data;
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
      // 회원가입 성공 - True / False
      return response.data.toString();
    } catch (e) {
      debugPrint('Error signin: $e');
      return 'Error';
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
      debugPrint('Error LikeList : $e');
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
      debugPrint('Error Profile : $e');
      return -1;
    }
  }

  Future interactionClick(
      {required String username,
      required String albumName,
      required String artistName,
      required String trackName}) async {
    late Response response;
    try {
      response = await _dio
          .get('/interaction/$username/$albumName/$artistName/$trackName/0');
      debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error Interaction Click : $e');
      return -1;
    }
  }

  Future interactionLike(
      {required String username,
      required String albumName,
      required String artistName,
      required String trackName}) async {
    late Response response;
    try {
      response = await _dio
          .get('/interaction/$username/$albumName/$artistName/$trackName/1');
      debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error interactionLike : $e');
      return -1;
    }
  }

  Future interactionDelete(
      {required String username,
      required String albumName,
      required String artistName,
      required String trackName}) async {
    late Response response;
    try {
      response = await _dio
          .get('/interaction/$username/$albumName/$artistName/$trackName/2');
      debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error interactionDelete : $e');
      return -1;
    }
  }
}

class DioModel {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://27.96.134.64:30001',
    ),
  )..interceptors.add(Logging());

  Future profile({required String name}) async {
    late Response response;
    try {
      response = await _dio.get('users/' + name + '/infer');
      debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }
}
