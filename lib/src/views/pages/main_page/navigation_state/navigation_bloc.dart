import 'package:flutter/foundation.dart' show ValueNotifier;

// class NavigationBloc {
//   NavigationBloc();

//   final _navigationSubject = BehaviorSubject<int>.seeded(0);

//   int get pageIndex => _navigationSubject.value;
//   Stream<int> get navigationStream => _navigationSubject.stream;

//   void navigation(int index) {
//     if (index == pageIndex) {
//       return;
//     }
//     _navigationSubject.sink.add(index);
//   }
// }

class NavigationBloc extends ValueNotifier<int> {
  NavigationBloc() : super(0);

  int get currentIndex => value;

  // ignore: avoid_setters_without_getters
  set navigation(int index) {
    if (value == index) {
      return;
    }
    value = index;
  }
}
