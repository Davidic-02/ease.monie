import 'package:dio/dio.dart';
import 'package:esae_monie/blocs/bank_transfer/bank_transfer_bloc.dart';
import 'package:esae_monie/blocs/bottom_navbar/bottom_navbar_bloc.dart';
import 'package:esae_monie/blocs/location/location_bloc.dart';
import 'package:esae_monie/config/app.dart';
import 'package:esae_monie/config/env_helper.dart';
import 'package:esae_monie/config/env_keys.dart';
import 'package:esae_monie/repository/atm_repository.dart';
import 'package:esae_monie/retrofit/atm_api.dart';
import 'package:esae_monie/retrofit/bank_api.dart';
import 'package:esae_monie/services/logger.dart';
import 'package:esae_monie/services/services_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final flutterwaveDio = Dio();
  final baseUrl = dotenv.env[EnvKeys.baseUrl] ?? '';
  assert(
    dotenv.env[EnvKeys.flutterWaveSecretKey]?.isNotEmpty == true,
    'FLUTTERWAVE_SECRET_KEY missing from .env',
  );
  assert(Env.googleKey.isNotEmpty, 'GOOGLE_MAPS_API_KEY is missing');

  flutterwaveDio.options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: baseHeaders, // ← use your existing baseHeaders here
  );

  final googleDio = Dio();
  googleDio.options = BaseOptions(
    baseUrl: Env.googleBaseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  );

  googleDio.interceptors.add(GoogleApiKeyInterceptor(Env.googleKey));
  final googleBaseUrl = Env.googleBaseUrl;

  if (kDebugMode) {
    flutterwaveDio.interceptors.add(ResponseLoggingInterceptor());
    googleDio.interceptors.add(ResponseLoggingInterceptor());
  }

  getIt.registerSingleton<BankApi>(BankApi(flutterwaveDio, baseUrl: baseUrl));
  getIt.registerSingleton<ATMApi>(ATMApi(googleDio, baseUrl: googleBaseUrl));
  getIt.registerSingleton<AtmRepository>(AtmRepository(getIt<ATMApi>()));
  getIt.registerSingleton<LocationBloc>(LocationBloc());
  getIt.registerSingleton<BottomNavbarBloc>(BottomNavbarBloc());
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<BankTransferBloc>(BankTransferBloc());
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Query params: ${options.queryParameters}');
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    print('Response: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    print('Error: ${err.message}');
    print('Response: ${err.response?.data}');
    return super.onError(err, handler);
  }
}
