import 'package:dio/dio.dart' show Dio;
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, User, FirebaseException;
import 'package:papa_burger/src/restaurant.dart'
    show logger, EmailAlreadyRegisteredApiException;

typedef UserTokenSupplier = Future<String?> Function();

enum AuthStatus { unknown, signedIn, signedOut }

// Creating an API class in order to make an API calls then to send them to other declared Repositories
// such as User Repository and Restaurant Repository in order to make the code clearer
class Api {
  Api({
    // required UserTokenSupplier userTokenSupplier,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    // _dio.setUpAuthHeaders(userTokenSupplier);
    // _dio.interceptors.add(LogInterceptor(responseBody: false));
    _dio.options.connectTimeout = 5 * 1000;
    _dio.options.receiveTimeout = 5 * 1000;
    _dio.options.sendTimeout = 5 * 1000;
  }

  final Dio _dio;

  // static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User> signIn(String email, String password) async {
  //   // Building a url in order to LogIn
  //   final url = _urlBuilder.buildLogInUrl();
  //   // Creating a response so when we call signIn function we will be able to declare what user types
  //   // in order to give a response afterwards
  //   final requestJsonBody = {"email": email, "password": password};
  //   // Make an API post call
  //   final response = await _dio.post(url, data: requestJsonBody);
  //   // Make a variable so we can get in touch with an API data, taken from the API post call
  //   final jsonObject = response.data;
  //   try {
  //     // Here we are creating a new user according to the jsonObject
  //     final user = User.fromJson(jsonObject);
  //     // Then we returning that user in order to finish Future call and to return User after signIn
  //     return user;
  //   } on DioError catch (error) {
  //     // Here we check if there is any errors. if the error is == 400
  //     // we trhow an error InvalidCredentials otherwise we just rethrow
  //     if (error.response?.statusCode == 400) {
  //       logger.e('Invalid Credentials');
  //       throw InvalidCredentialsApiException();
  //     }
  //     if (error.type == DioErrorType.connectTimeout ||
  //         error.type == DioErrorType.receiveTimeout ||
  //         error.type == DioErrorType.sendTimeout) {
  //       logger.e(error.type);
  //       logger.e(error.message);
  //     }

  //     logger.e(error.message);
  //     rethrow;
  //   }
  // }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredentical = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = userCredentical.user;
      return firebaseUser;
    } on FirebaseException catch (e) {
      logger.e(e.code);
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyRegisteredApiException();
      }
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredentical = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = userCredentical.user;

      return firebaseUser;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  void logOut() {
    try {
      _auth.signOut();
    } on FirebaseException catch (e) {
      logger.e(e.toString());
    }
  }

  // Testing google Sign In
  // Future<User> googleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     // At this point, you can use the Google Sign-In credentials to authenticate the user with your own authentication system.
  //     return loggedInUser;
  //   } catch (error) {
  //     logger.e(error);
  //     rethrow;
  //   }
  // }
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
