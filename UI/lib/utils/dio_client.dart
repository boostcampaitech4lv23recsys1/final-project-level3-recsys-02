// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:ui/models/user.dart';
import 'package:ui/utils/logging.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1',
    ),
  )..interceptors.add(Logging());

  Future<User?> getUser({required String email}) async {
    User? user;

    try {
      Response userData = await _dio.get('/users/$email');

      print('User Info: ${userData.data}');

      user = User.fromJson(userData.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

    return user;
  }

  Future<User?> createUser({required User user}) async {
    User? retrievedUser;

    try {
      Response response = await _dio.post(
        '/users/',
        data: user.toJson(),
      );

      print('User created: ${response.data}');

      retrievedUser = User.fromJson(response.data);
    } catch (e) {
      print('Error creating user: $e');
    }

    return retrievedUser;
  }
}
