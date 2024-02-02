import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fe_lab_clinicas_core/src/rest_client/interceptors/auth_interceptor.dart';

const dioAuthKey = 'DIO_AUTH_KEY';

final class RestClient extends DioForNative {
  RestClient(String baseUrl)
      : super(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 60),
          ),
        ) {
    interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(),
    ]);
  }

  RestClient get auth {
    options.extra[dioAuthKey] = true;
    return this;
  }

  RestClient get unAuth {
    options.extra[dioAuthKey] = false;
    return this;
  }
}
