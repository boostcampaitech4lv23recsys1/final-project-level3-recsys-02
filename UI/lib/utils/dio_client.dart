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
    ),
  )..interceptors.add(Logging());

  get option => null;

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
