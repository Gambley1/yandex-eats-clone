import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:papa_burger/src/restaurant.dart' show logger;

@immutable
class NavigationBloc {
  NavigationBloc();

  final _navigationSubject = BehaviorSubject<int>.seeded(0);

  int get pageIndex => _navigationSubject.value;
  Stream<int> get navigationStream => _navigationSubject.stream;

  void navigation(int index) {
    logger.i('index is $index');
    _navigationSubject.sink.add(index);
  }
}
