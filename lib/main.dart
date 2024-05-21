import 'package:papa_burger/bootstrap.dart';
import 'package:papa_burger/src/app/app.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';

void main() async {
  final userApi = UserApi();
  final userRepository = UserRepository(userApi: userApi);

  await bootstrap(() => App(userRepository: userRepository));
}
