part of 'event_setting_bloc.dart';

@immutable
class EventSettingEvent {}

final class EventSettingEventAddingEvent extends EventSettingEvent {
  final String eventTitle;
  final String eventDate;
  final String eventStartingTime;
  final String eventEndingTime;
  final String eventDiscripion;
  final String eventColor;
  EventSettingEventAddingEvent({
    required this.eventTitle,
    required this.eventDate,
    required this.eventStartingTime,
    required this.eventEndingTime,
    required this.eventDiscripion,
    required this.eventColor,
  });
}

final class EventSettingLoadingEvent extends EventSettingEvent {}
