import 'package:dio/dio.dart' show Dio;
import 'package:papa_burger/src/restaurant.dart' show defaultTimeout;

typedef UserTokenSupplier = Future<String?> Function();

// Creating an API class in order to make an API calls then to send them to
// other declared Repositories
// such as User Repository and Restaurant Repository in order to make
// the code clearer
class Api {
  Api({
    // required UserTokenSupplier userTokenSupplier,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    // _dio.setUpAuthHeaders(userTokenSupplier);
    // _dio.interceptors.add(LogInterceptor(responseBody: false));
    _dio.options.connectTimeout = defaultTimeout;
    _dio.options.receiveTimeout = defaultTimeout;
    _dio.options.sendTimeout = defaultTimeout;
  }

  final Dio _dio;
}

// // Declaring appToken into the Authorization field to access API calls
// extension on Dio {
//   static const _appTokenEnvironmentVariableKey = 'fav-qs-app-token';

//   void setUpAuthHeaders(UserTokenSupplier userTokenSupplier) {
//     const appToken = String.fromEnvironment(
//       _appTokenEnvironmentVariableKey,
//     );
//     options = BaseOptions(headers: {
//       'Authorization': 'Token token=$appToken',
//     });
//     interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           String? userToken = await userTokenSupplier();
//           if (userToken != null) {
//             options.headers.addAll({
//               'User-Token': userToken,
//             });
//           }
//           return handler.next(options);
//         },
//       ),
//     );
//   }
// }
