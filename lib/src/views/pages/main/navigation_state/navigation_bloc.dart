import 'package:flutter/foundation.dart' show ValueNotifier;

class NavigationBloc extends ValueNotifier<int> {
  factory NavigationBloc() => _instance;

  NavigationBloc._() : super(0);

  static final _instance = NavigationBloc._();

  int get currentIndex => value;

  // ignore: avoid_setters_without_getters
  set navigation(int index) {
    if (value == index) {
      return;
    }
    value = index;
  }
}
