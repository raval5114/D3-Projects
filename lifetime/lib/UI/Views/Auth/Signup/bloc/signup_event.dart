part of 'signup_bloc.dart';

@immutable
class SignupEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final String dob;
  const SignupEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dob,
  });
}
