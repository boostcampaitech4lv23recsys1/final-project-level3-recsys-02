import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui/models/user.dart';
import 'package:ui/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8002',
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
        pref.setString('user_id', response.data.toString());
        return 'Success';
      }
    } catch (e) {
      debugPrint('Error login : $e');
    }
  }

  Future getArtists() async {
    try {
      Response response = await _dio.get('/signin/artists');

      return response.data;
    } catch (e) {
      debugPrint('Error get Artist : $e');
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
      {required String userId,
      required int trackId,
      required String album_name}) async {
    late Response response;
    try {
      response = await _dio.get('/interaction/$userId/$trackId/$album_name/0');
      debugPrint(response.toString());
      String responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error Interaction Click : $e');
      return -1;
    }
  }

  Future interactionLike(
      {required String userId,
      required int trackId,
      required String album_name}) async {
    late Response response;
    try {
      response = await _dio.get('/interaction/$userId/$trackId/$album_name/1');
      debugPrint(response.toString());
      String responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error interactionLike : $e');
      return -1;
    }
  }

  Future interactionDelete(
      {required String userId, required int trackId}) async {
    late Response response;
    try {
      response = await _dio.get('/interaction/$userId/$trackId/2');
      debugPrint(response.toString());
      String responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error interactionDelete : $e');
      return -1;
    }
  }

  Future followUser({
    required String usernameA,
    required String usernameB,
  }) async {
    late Response response;
    try {
      response = await _dio.get('/follow/$usernameA/$usernameB');
      debugPrint(response.toString());
      return true;
    } catch (e) {
      debugPrint('Error followingFollower : $e');
      return -1;
    }
  }

  Future unfollowUser({
    required String usernameA,
    required String usernameB,
  }) async {
    late Response response;
    try {
      response = await _dio.get('/unfollow/$usernameA/$usernameB');
      debugPrint(response.toString());
      return response.data;
    } catch (e) {
      debugPrint('Error followingFollower : $e');
      return -1;
    }
  }

  Future getDailyChart() async {
    late Response response;
    try {
      response = await _dio.get('/toptrack');
      //debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error LikeList : $e');
    }
  }

  Future getSearchTrack({required String track}) async {
    late Response response;
    try {
      response = await _dio.get('/get_search_track/$track');
      return response.data;
    } catch (e) {
      debugPrint('Error getSearchTrack : $e');
      return -1;
    }
  }

  Future getTrackDetail(int trackId) async {
    late Response response;
    try {
      response = await _dio.get('/get_track_detail/$trackId');
      // debugPrint(response.toString());
      return response.data[0];
    } catch (e) {
      debugPrint('Error getTrackDetail : $e');
      return -1;
    }
  }

  Future get_usertasts(String user_id) async {
    late Response response;
    try {
      response = await _dio.get('/$user_id/tasts');
      // debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error getTrackDetail : $e');
      return -1;
    }
  }

  Future get_user_pref_review({required String user_id}) async {
    late Response response;
    try {
      response = await _dio.get('/$user_id/reviews');

      if (response.statusCode == 404) {
        return '이제 알듯 말듯 하네요. 조금만 더 평가해주세요!';
      }
      debugPrint(response.toString());
      return '가장 음악을 많이 듣는 시간대 ${response.data['freq_time']}시';
    } catch (e) {
      debugPrint('Error get_user_pref_review : $e');
      return 'Error';
    }
  }
}

class DioModel {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://27.96.134.64:30001',
    ),
  )..interceptors.add(Logging());

  Future recMusic({required String name}) async {
    late Response response;
    try {
      response = await _dio.post('/recomendation_music', data: '0');
      // debugPrint(response.toString());
      Map responseBody = response.data;

      return responseBody;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }

  Future recUser({required String name}) async {
    late Response response;
    try {
      response = await _dio.post('/recomendation_user', data: '0');
      // debugPrint(response.toString());
      List responseBody = response.data;
      return responseBody;
    } catch (e) {
      debugPrint('Error creating user: $e');
      return -1;
    }
  }
}
