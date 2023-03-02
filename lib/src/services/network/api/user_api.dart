import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:papa_burger/src/restaurant.dart';

typedef UserTokenSupplier = Future<String?> Function();

// Creating an API class in order to make an API calls then to send them to other declared Repositories
// such as User Repository and Restaurant Repository in order to make the code clearer
class Api {
  Api({
    // required UserTokenSupplier userTokenSupplier,
    required Prefs prefs,
    Dio? dio,
    UrlBuilder? urlBuilder,
  })  : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? const UrlBuilder(),
        _prefs = prefs {
    // _dio.setUpAuthHeaders(userTokenSupplier);
    // _dio.interceptors.add(LogInterceptor(responseBody: false));
    _dio.options.connectTimeout = 5 * 1000;
    _dio.options.receiveTimeout = 5 * 1000;
    _dio.options.sendTimeout = 5 * 1000;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Dio _dio;
  final Prefs _prefs;
  final UrlBuilder _urlBuilder;

  Future<User> signIn(String email, String password) async {
    // Building a url in order to LogIn
    final url = _urlBuilder.buildLogInUrl();
    // Creating a response so when we call signIn function we will be able to declare what user types
    // in order to give a response afterwards
    final requestJsonBody = {"email": email, "password": password};
    // Make an API post call
    final response = await _dio.post(url, data: requestJsonBody);
    // Make a variable so we can get in touch with an API data, taken from the API post call
    final jsonObject = response.data;
    try {
      // Here we are creating a new user according to the jsonObject
      final user = User.fromJson(jsonObject);
      // Then we returning that user in order to finish Future call and to return User after signIn
      return user;
    } on DioError catch (error) {
      // Here we check if there is any errors. if the error is == 400
      // we trhow an error InvalidCredentials otherwise we just rethrow
      if (error.response?.statusCode == 400) {
        logger.e('Invalid Credentials');
        throw InvalidCredentialsApiException();
      }
      if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.receiveTimeout ||
          error.type == DioErrorType.sendTimeout) {
        logger.e(error.type);
        logger.e(error.message);
      }

      logger.e(error.message);
      rethrow;
    }
  }

  // Testing google Sign In
  Future<User> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      // At this point, you can use the Google Sign-In credentials to authenticate the user with your own authentication system.

      // Create a new User object
      final loggedInUser = User(
        username: googleUser.displayName,
        email: googleUser.email,
        token: googleAuth.accessToken!,
      );
      return loggedInUser;
    } catch (error) {
      logger.e(error);
      rethrow;
    }
  }

  Future<void> signOut() async {
    // Here we building a url to SignOut
    final url = _urlBuilder.buildSingOutUrl();
    // Making an API delete call
    await _dio.delete(url);
    // Using SharedPreferences to cache our data we have to delete it aftern the user signed out
    // so afterwards he has no cached data
    await _prefs.deleteData();
  }
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
