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
  Future interactionClick({required String username, required Item itemInfo}) async {
    late Response response;
    try {
      var inputs =
       {
        "input_1": {
          "user_name": username,
          "password": "string",
          "realname": "string",
          "image": "string",
          "country": "string",
          "age": 0,
          "gender": 0,
          "playcount": 0,
          "following": [
            "string"
          ],
          "follower": [
            "string"
          ],
          "result": "string"
        },
        "input_2": {
          "track_name": itemInfo.name,
          "loved": 0,
          "album_name": itemInfo.albumName,
          "date_uts": 0,
          "artist_name": itemInfo.artistName
        },
        "option": {
          "option": 0
        }};
      debugPrint(inputs.toString());
      response = await _dio.post("/users/interaction", data: inputs);
      debugPrint(response.toString());
      return response.statusCode;

    } catch (e) {
      debugPrint('Error Add Click Interaction: $e');
      return -1;
    }
  }

  // Future connect() async {
  //   try {
  //     String response = await _dio.post('/users')
  //
  //     debugPrint(response.toString());
  //     return 200;
  //
  //   } catch (e) {
  //     debugPrint('Error Add Click Interaction: $e');
  //     return -1;
  //   }
  // }
  // Future interaction_append_like({required UserInfo userInfo, required Item itemInfo}) async {
  //   late Response response;
  //   user_id = userInfo.name;
  //   track_name = itemInfo.name;
  //   try {
  //     response = await _dio.post('/users/{user_id}/likes/{track_name}', data: (userInfo.toJson()), itemInfo.toJson(), 1);
  //     debugPrint(response.toString());
  //     return response.statusCode;
  //   } catch (e) {
  //     debugPrint('Error Add Like Interaction: $e');
  //     return -1;
  //   }
  // }
  //
  // Future interaction_append_delete({required UserInfo userInfo, required Item itemInfo}) async {
  //   late Response response;
  //
  //   try {
  //     response = await _dio.post('/users/{user_id}/likes/{track_name}', data: (userInfo.toJson()), itemInfo.toJson(), 2);
  //     debugPrint(response.toString());
  //     return response.statusCode;
  //   } catch (e) {
  //     debugPrint('Error Add Delete Interaction: $e');
  //     return -1;
  //   }
  // }
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
