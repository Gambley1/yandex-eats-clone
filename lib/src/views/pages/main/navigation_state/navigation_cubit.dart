import 'package:bloc/bloc.dart';
import 'package:papa_burger/src/restaurant.dart' show NavigationState;

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(
          NavigationState(),
        );

  void navigation(int newIndex) {
    emit(
      state.copyWith(
        currentIndex: newIndex,
      ),
    );
  }
}
