import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger_server/api.dart' as server;

class UserApi implements BaseUserRepository {
  UserApi({server.ApiClient? apiClient})
      : _apiClient = apiClient ?? server.ApiClient();

  final server.ApiClient _apiClient;

  @override
  Future<User> login(String email, String password) async {
    try {
      final user =
          await _apiClient.login(email, password).timeout(defaultTimeout);
      return User.fromDb(user!);
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<User> signUp(
    String username,
    String email,
    String password, {
    String profilePicture = '',
  }) async {
    try {
      final user = await _apiClient
          .register(
            username,
            email,
            password,
            profilePicture: profilePicture,
          )
          .timeout(defaultTimeout);
      return User.fromDb(user!);
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<void> logout() =>
      throw UnimplementedError('logout() has not been implemented');
}

// Declaring appToken into the Authorization field to access API calls
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
