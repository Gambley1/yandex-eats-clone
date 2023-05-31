import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart' show Equatable;

part 'show_password_state.dart';

class ShowPasswordCubit extends Cubit<ShowPasswordState> {
  ShowPasswordCubit() : super(const ShowPasswordInit());

  void handleShowPassword({required bool showPassword}) {
    emit(HandleShowPassword(newTextObscure: showPassword));
  }
}
