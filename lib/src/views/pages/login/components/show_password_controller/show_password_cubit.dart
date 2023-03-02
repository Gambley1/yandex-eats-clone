import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_password_state.dart';

class ShowPasswordCubit extends Cubit<ShowPasswordState> {
  ShowPasswordCubit() : super(const ShowPasswordInit());

  void handleShowPassword(bool showPassword) {
    emit(HandleShowPassword(showPassword));
  }
}
