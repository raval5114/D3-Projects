part of 'notification_and_event_bloc.dart';

@immutable
sealed class NotificationAndEventState {}

final class NotificationAndEventInitial extends NotificationAndEventState {}

final class NotificationAndEventActionState extends NotificationAndEventState {}

final class NotificationAndEventLoadingState
    extends NotificationAndEventState {}

final class NotificationAndEventSuccessState extends NotificationAndEventState {
  final List<Map<String, dynamic>> data;
  NotificationAndEventSuccessState(this.data);
}

final class NotificationAndEventErrorState extends NotificationAndEventState {
  final String errorMsg;
  NotificationAndEventErrorState(this.errorMsg);
}
