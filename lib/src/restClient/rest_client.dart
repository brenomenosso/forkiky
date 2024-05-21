import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:forkify_app/src/core/env.dart';

final class RestClient extends DioForNative {

  RestClient(String baseUrl) : super (
    BaseOptions(
      baseUrl: Env.backendBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
    )
  ) {
    interceptors.addAll([
      LogInterceptor(
        requestBody: true, 
        responseBody: true, 
        requestHeader: true,
        responseHeader: true,
      ),
    ]);
  }

  RestClient get auth {
    return this;
  }

  RestClient get unAuth {
    return this;
  }
}