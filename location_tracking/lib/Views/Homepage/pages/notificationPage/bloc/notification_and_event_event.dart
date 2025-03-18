part of 'notification_and_event_bloc.dart';

@immutable
sealed class NotificationAndEventEvent {}

class NotificationAndEventPageEventCatchingEvent
    extends NotificationAndEventEvent {
  final String vechicleName;
  final String date;
  NotificationAndEventPageEventCatchingEvent({
    required this.vechicleName,
    required this.date,
  });
}
