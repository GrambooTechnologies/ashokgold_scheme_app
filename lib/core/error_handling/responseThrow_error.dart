import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

String resErrorThrow(Response response, String? extra) {
  return "Something went wrong! ${response.statusMessage}[${response.statusCode}]";
}

void customLog(dynamic message) {
  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  logger.e(message);
}
