import 'package:papa_burger/src/restaurant.dart' show MainBloc;

class MainPageService {
  MainPageService() {
    mainBloc = MainBloc();
  }
  late final MainBloc mainBloc;
}
