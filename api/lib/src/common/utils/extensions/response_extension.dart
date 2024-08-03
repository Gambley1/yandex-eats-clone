import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

extension ResponseX on Response {
  Response notFound() => Response(statusCode: HttpStatus.notFound);
  Response badRequest() => Response(statusCode: HttpStatus.badRequest);
  Response methodNotAllowed() =>
      Response(statusCode: HttpStatus.methodNotAllowed);
  Response noContent() => Response(statusCode: HttpStatus.noContent);
}
