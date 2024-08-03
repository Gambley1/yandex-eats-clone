// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:yandex_food_api/src/common/remote/token_interceptor.dart';

/// Signature for the authentication token provider.
typedef TokenProvider = Future<String?> Function();

/// {@template app_dio}
/// Application Dio client. Provides dio `http` client with logger interceptor.
/// {@endtemplate}
class AppDio {
  /// {@macro app_dio}
  AppDio({
    required TokenProvider tokenProvider,
    Dio? httpClient,
  }) : httpClient = httpClient ?? Dio()
          ..options.contentType = 'application/json'
          ..options.connectTimeout = _defaultTimeout
          ..options.receiveTimeout = _defaultTimeout
          ..options.sendTimeout = _defaultTimeout
          ..interceptors.add(
            LogInterceptor(
              request: false,
              requestHeader: false,
              responseHeader: false,
            ),
          )
          // ..interceptors.add(CacheInterceptor())
          ..interceptors.add(TokenInterceptor(tokenProvider: tokenProvider))
          ..httpClientAdapter = IOHttpClientAdapter();

  /// Dio `http` client.
  final Dio httpClient;

  static const _defaultTimeout = Duration(seconds: 20);
}
