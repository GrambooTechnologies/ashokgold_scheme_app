import 'package:dio/dio.dart';

Map<String, dynamic> handleApiResponse(Response response) {
  try {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final success = data['success'] == true;
      final message = data['message']?.toString() ?? '';
      if (!success) {
        throw Exception(message.isNotEmpty ? message : 'Request failed.');
      }
      return {
        'success': success,
        'message': message,
        'data': data['data'],
        'raw': data,
      };
    }
    // Fallback for unexpected response structure
    throw Exception('Unexpected response format.');
  } catch (e) {
    throw Exception(e.toString());
  }
}
