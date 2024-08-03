import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

/// Exception for request errors.
sealed class RequestException implements Exception {
  /// {@macro request_exception}
  const RequestException(this.error);

  /// Associated occured error.
  final Object error;

  @override
  String toString() => 'RequestException: $error';
}

/// Exception for request body errors.
final class RequestBodyException extends RequestException {
  /// {@macro request_body_exception}
  const RequestBodyException(super.error);
}

/// Extension for [RequestContext] to safely get JSON from request. Returns null
/// if request body is empty.
extension SafeRequestJSON on RequestContext {
  /// Returns JSON from request body.
  Future<Map<String, dynamic>?> safeJson() async {
    try {
      final body = await request.body();
      if (body.isEmpty) return null;
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RequestBodyException(error), stackTrace);
    }
  }

  /// Returns query parameters from request.
  Map<String, String> get queryParameters => request.url.queryParameters;

  /// Returns query parameter by [key].
  String? query(String key) => queryParameters[key];
}
