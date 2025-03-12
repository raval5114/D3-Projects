import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:life_time/UI/Views/OtherViews/EventSettingScreen/repos/eventSetting.dart';
import 'package:meta/meta.dart';

part 'event_setting_event.dart';
part 'event_setting_state.dart';

class EventSettingBloc extends Bloc<EventSettingEvent, EventSettingState> {
  EventSettingBloc() : super(EventSettingInitial()) {
    on<EventSettingEventAddingEvent>((event, emit) async {
      try {
        EventSettingRepo eventSetting = EventSettingRepo();
        eventSetting.addingEvents(
          eventTitle: event.eventTitle,
          eventDate: event.eventDate,
          eventStartTime: event.eventStartingTime,
          eventEndTime: event.eventEndingTime,
          eventDescription: event.eventDiscripion,
          eventColor: event.eventColor,
        );
        emit(EventSettingEventAddedState());
      } catch (e) {
        emit(EventSettingErrorState(errorMessage: e.toString()));
      }
    });
    on<EventSettingLoadingEvent>((event, emit) async {
      try {
        emit(EventSettingLoadingState());
        EventSettingRepo eventSettingRepo = EventSettingRepo();
        List<CalendarEventData> events = await eventSettingRepo.loadEvents();
        emit(EventSettingSuccessState(events: events));
        debugPrint("Events:${events.length}");
      } catch (e) {
        emit(EventSettingErrorState(errorMessage: e.toString()));
        debugPrint(e.toString());
      }
    });
  }
}
