part of 'signin_bloc.dart';

@immutable
sealed class SigninState {}

final class SigninInitial extends SigninState {}

final class SigninActionState extends SigninState {}

final class SigninSuccessState extends SigninActionState {}

final class SigninLoadingState extends SigninActionState {}

final class SigninErrorState extends SigninActionState {
  final String message;

  SigninErrorState(this.message);
}
