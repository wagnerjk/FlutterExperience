import 'package:dio/dio.dart';
import 'package:fe_lab_clinicas_core/src/constants/local_storage_constants.dart';
import 'package:fe_lab_clinicas_core/src/rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final RequestOptions(:headers, :extra) = options;
    const authHeaderKey = 'Authorization';
    headers.remove(authHeaderKey);

    if (extra case {dioAuthKey: true}) {
      final sp = await SharedPreferences.getInstance();
      headers.addAll(
        {authHeaderKey: 'Bearer ${sp.getString(LocalStorageConstants.accessToken)}'},
      );
    }
  }
}
