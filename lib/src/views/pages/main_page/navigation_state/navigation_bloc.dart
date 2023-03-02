import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class NavigationBloc {
  NavigationBloc();

  final navigationSubject = BehaviorSubject<int>.seeded(0);

  int get pageIndex => navigationSubject.value;

  void navigation(int index) {
    logger.i('index is $index');
    navigationSubject.sink.add(index);
  }
}
