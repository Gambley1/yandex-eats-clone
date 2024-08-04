import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response().methodNotAllowed();
  }

  const secret = String.fromEnvironment('PGHOST');

  print(secret);

  return Response(
    statusCode: secret.isEmpty ? HttpStatus.badRequest : HttpStatus.created,
  );
}
