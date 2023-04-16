import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart'
    show ThrottleExtensions, DelayExtension, BehaviorSubject, Rx;
import 'package:papa_burger/src/restaurant.dart'
    show
        Cart,
        CartState,
        GoogleRestaurant,
        Item,
        LocalStorageRepository,
        NavigatorExtension,
        Restaurant,
        RestaurantService,
        logger;

class CartBloc {
  static final CartBloc _instance = CartBloc._privateConstructor();

  factory CartBloc() => _instance;

  CartBloc._privateConstructor();

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final RestaurantService _restaurantService = RestaurantService();

  final cartSubject = BehaviorSubject<CartState>.seeded(const CartState());
  final cartRestaurantIdSubject = BehaviorSubject<int>.seeded(0);
  final cartRestaurantPlaceIdSubject = BehaviorSubject<String>.seeded('');

  CartState get state => cartSubject.value;
  Set<Item> get cartItems => state.cart.cartItems;
  int get id => cartRestaurantIdSubject.value;
  String get placeId => cartRestaurantPlaceIdSubject.value;
  bool inCart(Item item) => cartItems.contains(item);
  bool idEqual(int restaurantId) => id == restaurantId;
  bool placeIdEqual(String restaurantPlaceId) => placeId == restaurantPlaceId;
  bool idEqualToRemove(int restaurantId) => idEqual(restaurantId) || id == 0;
  bool placeIdEqualToRemove(String restaurantId) =>
      placeIdEqual(restaurantId) || placeId.isEmpty;

  Restaurant getRestaurantById(int id) => _restaurantService.restaurantById(id);
  GoogleRestaurant getRestaurantByPlaceId(String placeId) =>
      _restaurantService.restaurantByPlaceId(placeId);

  Stream<CartState> getItems() {
    return cartSubject.distinct().asyncMap((state) async {
      try {
        final Set<Item> cachedItems = _localStorageRepository.getCartItems();
        final newState = state.copyWith(
          cart: Cart(
            cartItems: {...state.cart.cartItems}..addAll(cachedItems),
          ),
        );
        cartSubject.sink.add(newState);
        return newState;
      } catch (e) {
        logger.e(e.toString());
        cartSubject.addError(e.toString());
        rethrow;
      }
    }).delay(const Duration(seconds: 1));
  }

  Stream<int> restaurantId() {
    return cartRestaurantIdSubject
        .distinct()
        .throttleTime(const Duration(seconds: 1), trailing: true)
        .asyncMap((cartRestId) async {
      try {
        final id = _localStorageRepository.getRestId();
        logger.w('ID IS $id');
        cartRestId = id;
        cartRestaurantIdSubject.sink.add(id);
        return cartRestId;
      } catch (e) {
        logger.e(e.toString());
        cartRestaurantIdSubject.addError(e.toString());
        return 0;
      }
    });
  }

  Stream<String> restaurantPlaceId() {
    return cartRestaurantPlaceIdSubject
        .distinct()
        .throttleTime(const Duration(seconds: 1), trailing: true)
        .asyncMap((cartRestPlaceId) async {
      try {
        final placeId = _localStorageRepository.getRestPlaceId();
        logger.w('placeId IS $placeId');
        cartRestPlaceId = placeId;
        cartRestaurantPlaceIdSubject.sink.add(placeId);
        return cartRestPlaceId;
      } catch (e) {
        logger.e(e.toString());
        cartRestaurantPlaceIdSubject.addError(e.toString());
        return '';
      }
    });
  }

  Stream<CartState> get globalStream => Rx.combineLatest2(
        getItems(),
        restaurantId(),
        (cartState, cartRestaurantId) {
          final cartState$ = cartState as CartState;
          // final cartRestaurantId$ = cartRestaurantId as int;
          return cartState$;
        },
      );

  Stream<CartState> get globalStreamTest => Rx.combineLatest2(
        getItems(),
        restaurantPlaceId(),
        (cartState, cartRestaurantId) {
          final cartState$ = cartState as CartState;
          // final cartRestaurantId$ = cartRestaurantId as int;
          return cartState$;
        },
      );

  void addRestaurantIdToCart(int id) async {
    try {
      _localStorageRepository.addId(id);
    } catch (e) {
      logger.e(e.toString());
      cartRestaurantIdSubject.addError(e.toString());
    }
  }

  void addRestaurantPlaceIdToCart(String placeId) async {
    try {
      _localStorageRepository.addPlaceId(placeId);
    } catch (e) {
      logger.e(e.toString());
      cartRestaurantPlaceIdSubject.addError(e.toString());
    }
  }

  void addItemToCart(Item item) async {
    try {
      _localStorageRepository.addItem(item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..add(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void removeItemFromCartItem(Item item) async {
    try {
      _localStorageRepository.removeItem(item);
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..remove(item),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void removeAllItemsFromCartAndRestaurantId() async {
    try {
      _localStorageRepository.removeAllItems();
      _localStorageRepository.setRestIdTo0();
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..removeAll(state.cart.cartItems),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  void removeAllItemsFromCartAndRestaurantPlaceId() async {
    try {
      _localStorageRepository.removeAllItems();
      _localStorageRepository.setRestPlaceIdToEmpty();
      final newState = state.copyWith(
        cart: Cart(
          cartItems: {...state.cart.cartItems}..removeAll(state.cart.cartItems),
        ),
      );
      cartSubject.sink.add(newState);
    } catch (e) {
      logger.e(e.toString());
      cartSubject.addError(e.toString());
    }
  }

  // void dispose() {
  //   cartSubject.close();
  //   cartRestaurantIdSubject.close();
  // }
}

class CartBlocTest extends ValueNotifier<Cart> {
  static final CartBlocTest _instance = CartBlocTest._privateConstructor(
    const Cart(),
  );

  factory CartBlocTest() => _instance;

  CartBlocTest._privateConstructor(super.value) {
    logger.w('Inits Singleton Cart Bloc Test');
    if (value.cartEmpty) {
      _getItemsFromCache();
    }
  }

  final LocalStorageRepository _localStorageRepository =
      LocalStorageRepository();
  final RestaurantService _restaurantService = RestaurantService();

  GoogleRestaurant getRestaurant(String placeId) {
    return _restaurantService.restaurantByPlaceId(placeId);
  }

  void decreaseQuantity(
    BuildContext context,
    Item item, {
    GoogleRestaurant? restaurant,
    bool forMenu = false,
  }) {
    if (value.itemsTest[item]! > 1) {
      _decreaseQuantity(item);
    } else {
      removeItemFromCart(item).then(
        (_) {
          if (value.cartEmpty) {
            removePlaceIdInCacheAndCart();
            context.navigateToMenu(context, restaurant!, fromCart: true);
          }
        },
      );
    }
  }

  void increaseQuantity(Item item) {
    if (_allowIncrease(item)) _increaseQuantity(item);
  }

  bool allowIncrease(Item item) => _allowIncrease(item);

  void _getItemsFromCache() async {
    final cachedItems = _localStorageRepository.getCartItems();
    final cachedItemsTest = _localStorageRepository.getCartItemTest;
    final restaurantPlaceId = _localStorageRepository.getRestPlaceId();
    value = value.copyWith(
      restaurantPlaceId: restaurantPlaceId,
      cartItems: {...value.cartItems}..addAll(cachedItems),
      itemsTest: {...value.itemsTest}..addAll(cachedItemsTest),
    );
  }

  void addItemToCart(Item item, {required String placeId}) async {
    logger.w('++++ ADDING ITEM TO CART $item WITH PLACE ID $placeId ++++');
    // logger.w('ADD WITH ID? $withPlaceId');

    /// Adding item to local storage Hive.
    _localStorageRepository.addItem(item);
    _localStorageRepository.addPlaceId(placeId);
    _localStorageRepository.addItemTest(item);

    logger.w('CART BEFORE ADDING ITEM $value');
    final newPlaceId = value.copyWith(
      restaurantPlaceId: placeId,
      cartItems: {...value.cartItems}..add(item),
      itemsTest: {...value.itemsTest}..putIfAbsent(item, () => 1),
    );
    // value = withPlaceId ? newPlaceId : newCartItems;
    value = newPlaceId;
    logger.w('++++ CART AFTER ADDING ITEM $value ++++');
  }

  void _increaseQuantity(Item item) {
    logger.w('++++ INCREASING QUANTITY ON ITEM $item IN CART BLOC ++++');
    _localStorageRepository.increaseQuantity(item);

    final increase = value.copyWith(
      itemsTest: {...value.itemsTest}..update(
          item,
          (value) => value + 1,
        ),
    );
    value = increase;
    logger.w('++++ CART AFTER INCREASING QUANTITY ${value.itemsTest} ++++');
  }

  void _decreaseQuantity(Item item) {
    logger.w('---- DECREASING QUANTITY ON ITEM $item IN CART BLOC ----');
    _localStorageRepository.decreaseQuantity(item);

    if (value.itemsTest[item]! > 1) {
      final decrease = value.copyWith(
        itemsTest: {...value.itemsTest}..update(item, (value) => value - 1),
      );
      value = decrease;
      logger.w('---- CART AFTER DECREASING QUANTITY ${value.itemsTest} ----');
    } else {
      _localStorageRepository.removeItem(item);
      final removeItem = value.copyWith(
        itemsTest: {...value.itemsTest}..remove(item),
      );
      value = removeItem;
      logger.w(
          '---- CART AFTER REMOVING ITEM WHEN DECREASING QUANTITY $value ----');
    }
  }

  bool _allowIncrease(Item item) {
    if (value.itemsTest[item]! < 100) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeItemFromCart(Item item) async {
    logger.w('---- REMOVING ITEM FROM CART $item ----');

    /// Removing from local storage Hive.
    _localStorageRepository.removeItem(item);

    logger.w('CART BEFORE REMOVING ITEM $value');
    final newCart = value.copyWith(
      cartItems: {...value.cartItems}..remove(item),
      itemsTest: {...value.itemsTest}..remove(item),
    );
    value = newCart;
    logger.w('---- CART AFTER REMOVING ITEM $value ----');
  }

  Future<void> removeAllItems() async {
    logger.w('---- REMOVING ALL ITEMS FROM CART ----');

    /// ----------------------------------------------------------------------- ///
    logger.w('REMOVING ALL ITEMS FROM LOCAL STORAGE HIVE');
    logger.w(
        'CACHED CART ITEMS BEFORE REMOVING FROM CART ${_localStorageRepository.getCartItems()} &&&& PLACE ID IN CART ${_localStorageRepository.getRestPlaceId()}');
    _localStorageRepository.removeAllItems();
    logger.w(
        'CACHED CART ITEMS AFTER REMOVING FROM CART ${_localStorageRepository.getCartItems()} &&&& PLACE ID IN CART ${_localStorageRepository.getRestPlaceId()}');

    /// ----------------------------------------------------------------------- ///

    logger.w('CART BEFORE REMOVING ALL ITEMS $value');
    value = value.copyWith(
      restaurantPlaceId: '',
      cartItems: {...value.cartItems}..removeAll(value.cartItems),
      itemsTest: {...value.itemsTest}..clear(),
    );
    logger.w('---- CART AFTER REMOVING ALL ITEMS $value ----');
  }

  void addItemToCartAfterCallingClearCart(Item item, String placeId) async {
    /// 1.First removing all items from cart, both cached and current storing items.
    ///
    /// 3.Then adding chosen item to cart with place id of the restaurant.
    removeAllItems().then(
      (_) => addItemToCart(item, placeId: placeId),
    );
  }

  Future<void> removePlaceIdInCacheAndCart() async {
    logger.w('---- REMOVE PLACE ID FROM CART ----');
    logger.w('CART BEFORE REMOVING PLACE ID $value');
    logger.w(
        'CACHED PLACE ID IN CART BEFORE REMOVING ${_localStorageRepository.getRestPlaceId()}');
    _localStorageRepository.setRestPlaceIdToEmpty();
    final newCart = value.copyWith(
      restaurantPlaceId: '',
    );
    value = newCart;
    logger.w(
        'CACHED PLACE ID IN CART AFTER REMOVING ${_localStorageRepository.getRestPlaceId()}');
    logger.w('---- CART AFTER REMOVING PLACE ID $value ----');
  }
}
