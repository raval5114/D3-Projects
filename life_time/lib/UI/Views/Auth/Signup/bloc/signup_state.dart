part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

class SignupActionState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupActionState {}

class SignupErrorState extends SignupActionState {
  final String errorMessage;

  SignupErrorState(this.errorMessage);
}
