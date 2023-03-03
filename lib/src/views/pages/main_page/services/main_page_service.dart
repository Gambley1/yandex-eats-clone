import 'package:papa_burger/src/restaurant.dart';

class MainPageService {
  late final MainBloc mainBloc;
  late final NavigationBloc navigationBloc;

  MainPageService() {
    mainBloc = MainBloc();
    navigationBloc = NavigationBloc();
  }
}
