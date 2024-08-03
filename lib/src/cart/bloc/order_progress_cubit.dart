import 'package:bloc/bloc.dart';

class OrderProgressCubit extends Cubit<String> {
  OrderProgressCubit() : super('00:00');

  void addCount(Duration duration) {
    final elapsed =
        '${(duration.inSeconds / 60).floor()}'
        ':${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    emit(elapsed);
  }
}
