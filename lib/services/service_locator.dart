import 'package:dio/dio.dart';
import 'package:esae_monie/config/app.dart';
import 'package:esae_monie/config/env_keys.dart';
import 'package:esae_monie/retrofit/bank_api.dart';
import 'package:esae_monie/services/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final baseUrl = dotenv.env[EnvKeys.baseUrl] ?? '';
  Dio dio = Dio(BaseOptions(baseUrl: baseUrl, headers: baseHeaders));

  if (kDebugMode) {
    print('DEBUG BASE_URL => ${dotenv.env[EnvKeys.baseUrl]}');
    dio.interceptors.add(ResponseLoggingInterceptor());
  }

  if (kDebugMode) {
    locator.registerFactory<BankApi>(
      () => BankApi(dio, baseUrl: dotenv.env[EnvKeys.baseUrl]),
    );
  } else {
    locator.registerSingleton<BankApi>(
      BankApi(dio, baseUrl: dotenv.env[EnvKeys.baseUrl]),
    );
  }
}
