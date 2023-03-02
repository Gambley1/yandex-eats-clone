part of 'show_password_cubit.dart';

abstract class ShowPasswordState extends Equatable {
  final bool textObscure;
  const ShowPasswordState(this.textObscure);

  @override
  List<Object> get props => [textObscure];
}

class ShowPasswordInit extends ShowPasswordState {
  const ShowPasswordInit() : super(true);
}

class HandleShowPassword extends ShowPasswordState {
  final bool newTextObscure;
  const HandleShowPassword(this.newTextObscure) : super(newTextObscure);
}
