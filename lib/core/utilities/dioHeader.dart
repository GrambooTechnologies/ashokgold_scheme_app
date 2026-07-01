import 'package:dio/dio.dart';

class DioHeader {
  static Options dioHeader({required String token}) {
    return Options(
      headers: {
        "authorization": token,
      },
    );
  }
}
