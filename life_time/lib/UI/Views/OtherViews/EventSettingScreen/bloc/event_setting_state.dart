part of 'event_setting_bloc.dart';

@immutable
sealed class EventSettingState {}

final class EventSettingInitial extends EventSettingState {}

final class EventSettingActionState extends EventSettingState {}

final class EventSettingEventAddedState extends EventSettingActionState {}

final class EventSettingLoadingState extends EventSettingState {}

final class EventSettingSuccessState extends EventSettingState {
  final List<CalendarEventData> events;
  EventSettingSuccessState({required this.events});
}

final class EventSettingErrorState extends EventSettingState {
  final String errorMessage;
  EventSettingErrorState({required this.errorMessage});
}
