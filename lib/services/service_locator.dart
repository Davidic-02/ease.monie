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
  Dio dio = Dio(BaseOptions(headers: baseHeaders));

  if (kDebugMode) {
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
