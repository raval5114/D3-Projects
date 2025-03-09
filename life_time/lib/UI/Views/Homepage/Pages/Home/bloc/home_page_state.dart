part of 'home_page_bloc.dart';

@immutable
sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomepageActionState extends HomePageState {}

final class HomePageLoadingState extends HomePageState {}

final class HomePageSuccessState extends HomePageState {}

final class HomePageErrorState extends HomePageState {
  String errorMessage;
  HomePageErrorState({required this.errorMessage});
}
