import 'package:bloc/bloc.dart';
import 'package:papa_burger/src/restaurant.dart';

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
