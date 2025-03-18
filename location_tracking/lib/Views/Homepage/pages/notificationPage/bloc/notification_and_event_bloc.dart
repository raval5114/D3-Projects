import 'package:bloc/bloc.dart';
import 'package:location_tracking/Data/Utils/eventData.dart';
import 'package:meta/meta.dart';

part 'notification_and_event_event.dart';
part 'notification_and_event_state.dart';

class NotificationAndEventBloc
    extends Bloc<NotificationAndEventEvent, NotificationAndEventState> {
  NotificationAndEventBloc() : super(NotificationAndEventInitial()) {
    on<NotificationAndEventPageEventCatchingEvent>((event, emit) async {
      try {
        emit(NotificationAndEventLoadingState());
        await Future.delayed(Duration(seconds: 2));
        emit(NotificationAndEventSuccessState(eventData));
      } catch (e) {
        emit(NotificationAndEventErrorState(e.toString()));
      }
    });
  }
}
