import 'package:papa_burger/src/restaurant.dart'
    show MainBloc;

class MainPageService {
  late final MainBloc mainBloc;

  MainPageService() {
    mainBloc = MainBloc();
  }
}
