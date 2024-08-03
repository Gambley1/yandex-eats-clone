import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:yandex_food_api/src/middleware/middleware.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(databaseProvider())
      .use(userProvider())
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'https://myfrontendurl.com',
            },
          ),
        ),
      );
}
