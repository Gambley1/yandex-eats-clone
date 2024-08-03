import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yandex_food_api/src/common/common.dart';
import 'package:yandex_food_api/src/common/remote/remote.dart';

class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor({required TokenProvider tokenProvider})
      : _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();
    options.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    handler.next(options);
  }
}
