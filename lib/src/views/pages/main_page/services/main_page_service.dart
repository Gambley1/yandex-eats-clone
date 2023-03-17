import 'package:papa_burger/src/restaurant.dart'
    show GoogleRestaurant, MainBloc;

class MainPageService {
  late final MainBloc mainBloc;
  late final List<GoogleRestaurant> restaurants;

  MainPageService() {
    mainBloc = MainBloc();
    restaurants = MainBloc.restaurants;
  }
}
