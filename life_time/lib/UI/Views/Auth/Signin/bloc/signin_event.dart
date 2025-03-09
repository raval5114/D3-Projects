part of 'signin_bloc.dart';

@immutable
class SigninEvent {
  final String email;
  final String password;
  const SigninEvent({required this.email, required this.password});
}
