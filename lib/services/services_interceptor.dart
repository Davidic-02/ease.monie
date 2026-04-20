import 'package:dio/dio.dart';

class GoogleApiKeyInterceptor extends Interceptor {
  final String apiKey;

  GoogleApiKeyInterceptor(this.apiKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['key'] = apiKey;
    super.onRequest(options, handler);
  }
}
