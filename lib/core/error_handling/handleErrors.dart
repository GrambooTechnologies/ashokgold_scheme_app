import 'package:ashokgold_scheme_app/core/error_handling/failure.dart';
import 'package:ashokgold_scheme_app/core/utilities/logger.dart';
import 'package:dio/dio.dart';

Failure handleErrors(Object error, StackTrace? s) {
  try {
    print(s);
    if (error is DioException) {
      logger.e('DioException:', error: error, stackTrace: error.stackTrace);
      return Failure(errMSg: handleApiError(error));
    }
    throw Exception('Unknown error: ${error.toString()}');
  } catch (e, s) {
    logger.e('Error in handleErrors:', error: e, stackTrace: s);

    return Failure(
      errMSg:
          "An unexpected error occurred. Please try again later.[${e.toString()}]",
    );
  }
}

String handleApiError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return "Connection timed out. Please try again.";
  }
  if (error.response != null && error.response?.data != null) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message']?.toString() ?? "An unknown error occurred.";
      }
      if (data.containsKey('error')) {
        return data['error']?.toString() ?? "An unknown error occurred.";
      }
    }
    if (data is String) {
      return data;
    }
    if (data is List) {
      // Join list items into a single string
      return data.map((e) => e.toString()).join('\n');
    }
  }

  if (error.type == DioExceptionType.unknown) {
    return "Network error. Please check your connection.";
  }

  return "An unexpected error occurred. Please try again later. [${error.toString()}]";
}
