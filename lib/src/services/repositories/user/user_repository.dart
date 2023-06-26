import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show
        BaseUserRepository,
        CartBloc,
        LocalStorage,
        LocationNotifier,
        MainPageService,
        User,
        UserApi;
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required UserApi userApi,
    required LocalStorage localStorage,
    required CartBloc cartBloc,
    required MainPageService mainPageService,
    required SelectedCardNotifier selectedCardNotifier,
    required LocationNotifier locationNotifier,
  })  : _userApi = userApi,
        _localStorage = localStorage,
        _cartBloc = cartBloc,
        _mainPageService = mainPageService,
        _selectedCardNotifier = selectedCardNotifier,
        _locationNotifier = locationNotifier;

  final UserApi _userApi;
  final LocalStorage _localStorage;
  final CartBloc _cartBloc;
  final MainPageService _mainPageService;
  final SelectedCardNotifier _selectedCardNotifier;
  final LocationNotifier _locationNotifier;

  @override
  Future<User> login(String email, String password) async {
    final user = await _userApi.login(email, password);
    _localStorage
      ..saveUser(user.toJson())
      ..saveCookieUserCredentials(user.uid, user.email, user.username);
    return user;
  }

  @override
  Future<User> register(
    String name,
    String email,
    String password, {
    String profilePicture = '',
  }) async {
    final user = await _userApi.register(
      name,
      email,
      password,
      profilePitcture: profilePicture,
    );
    _localStorage
      ..saveUser(user.toJson())
      ..saveCookieUserCredentials(user.uid, user.email, user.username);
    return user;
  }

  @override
  Future<void> logout() async {
    await _cartBloc.removeAllItems();
    _localStorage.deleteUserCookies();
    _selectedCardNotifier.deleteCardSelection();
    _locationNotifier.clearLocation();
    _mainPageService.mainBloc.clearAllRestaurants;
  }
}
