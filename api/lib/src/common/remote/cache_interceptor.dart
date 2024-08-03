import 'dart:io';

import 'package:dio/dio.dart';

class CachedResponse<T> extends Response<T> {
  CachedResponse({
    required super.requestOptions,
    super.data,
    super.statusCode,
  }) : setDateTime = DateTime.now();

  factory CachedResponse.fromResponse(Response<T> response) {
    return CachedResponse<T>(
      requestOptions: response.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  final DateTime setDateTime;
}

class CacheInterceptor extends QueuedInterceptor {
  CacheInterceptor();

  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final key = options.uri.toString();
    final cachedResponse = _cache[key];

    if (cachedResponse != null &&
        DateTime.now().difference(cachedResponse.setDateTime).inSeconds <
            _delay.inSeconds) {
      return handler.resolve(cachedResponse);
    }
    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async { 
    final key = response.requestOptions.uri.toString();

    if (response.statusCode == HttpStatus.ok) {
      final cachedResponse = CachedResponse<dynamic>.fromResponse(response);
      _cache[key] = cachedResponse;
    }

    return handler.next(response);
  }

  static const Duration _delay = Duration(seconds: 5);
  static final Map<String, CachedResponse<dynamic>> _cache =
      <String, CachedResponse<dynamic>>{};
}
