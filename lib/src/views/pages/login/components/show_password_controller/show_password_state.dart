part of 'show_password_cubit.dart';

abstract class ShowPasswordState extends Equatable {
  const ShowPasswordState({required this.textObscure});
  final bool textObscure;

  @override
  List<Object> get props => [textObscure];
}

class ShowPasswordInit extends ShowPasswordState {
  const ShowPasswordInit() : super(textObscure: true);
}

class HandleShowPassword extends ShowPasswordState {
  const HandleShowPassword({required this.newTextObscure})
      : super(textObscure: newTextObscure);
  final bool newTextObscure;
}
