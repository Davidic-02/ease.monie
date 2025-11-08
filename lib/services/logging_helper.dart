import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

void logMessage(String message) {
  logInfo(message);
}

void logError(Object error, StackTrace? trace) {
  logger.e('An Error Occurred', error: error, stackTrace: trace);

  if (error is DioException) {
    logger.e(error.response?.data);
  }
}

void logInfo(dynamic message) {
  logger.i(message);
}
