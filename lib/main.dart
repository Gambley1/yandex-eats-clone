import 'package:env/env.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:location_repository/location_repository.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:permission_client/permission_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:shared/shared.dart';
import 'package:stripe_payments_client/stripe_payments_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/bootstrap.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';

void main() {
  bootstrap((sharedPreferences) async {
    final tokenStorage = InMemoryTokenStorage();
    final appDio = AppDio(tokenProvider: tokenStorage.readToken);

    final timersStorage = InMemoryTimersStorage();

    const permissionClient = PermissionClient();

    final persistentStorage =
        PersistentStorage(sharedPreferences: sharedPreferences);
    final persistentListStorage =
        PersistentListStorage(sharedPreferences: sharedPreferences);

    final apiClient =
        YandexEatsApiClient(dio: appDio, baseUrl: Env.yandexEatsApiUrl);
    final backgroundTimer =
        BackgroundTimer(timersStorage: timersStorage, apiClient: apiClient);

    final authenticationClient = FirebaseAuthenticationClient(
      tokenStorage: tokenStorage,
    );

    final restaurantsStorage =
        RestaurantsStorage(storage: persistentListStorage);
    final restaurantsRepository = RestaurantsRepository(
      apiClient: apiClient,
      storage: restaurantsStorage,
    );
    final locationRepository =
        LocationRepository(httpClient: appDio.httpClient);

    final userStorage = UserStorage(storage: persistentStorage);
    final userRepository = UserRepository(
      authenticationClient: authenticationClient,
      storage: userStorage,
    );

    final ordersRepository = OrdersRepository(
      apiClient: apiClient,
      backgroundTimer: backgroundTimer,
      wsOrdersStatus: WebSocket(Uri.parse('uri')),
    );

    final stripePaymentsClient = StripePaymentsClient(appDio: appDio);
    final paymentsRepository = PaymentsRepository(
      apiClient: apiClient,
      paymentsClient: stripePaymentsClient,
    );

    final notificationsClient = NotificationsClient();

    final notificationsStorage =
        NotificationsStorage(storage: persistentStorage);

    final notificationsRepository = NotificationsRepository(
      permissionClient: permissionClient,
      storage: notificationsStorage,
      notificationsClient: notificationsClient,
      wsUserNotifications: WebSocket(Uri.parse('uri')),
      wsNotifications: WebSocket(Uri.parse('uri')),
    );

    return App(
      userRepository: userRepository,
      ordersRepository: ordersRepository,
      locationRepository: locationRepository,
      paymentsRepository: paymentsRepository,
      restaurantsRepository: restaurantsRepository,
      notificationsRepository: notificationsRepository,
      user: await userRepository.user.first,
    );
  });
}
