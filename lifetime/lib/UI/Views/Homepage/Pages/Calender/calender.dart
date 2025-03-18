import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifetime/UI/Views/OtherViews/EventSettingScreen/EventingSetting.dart';
import 'package:lifetime/UI/Views/OtherViews/EventSettingScreen/bloc/event_setting_bloc.dart';
import 'package:shimmer/shimmer.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CalenderSection());
  }
}

class CalenderSection extends StatefulWidget {
  @override
  const CalenderSection({super.key});

  @override
  State<CalenderSection> createState() => _CalenderSectionState();
}

class _CalenderSectionState extends State<CalenderSection> {
  @override
  void initState() {
    super.initState();
    context.read<EventSettingBloc>().add(EventSettingLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventSettingBloc, EventSettingState>(
      listenWhen: (previous, current) => current is EventSettingActionState,
      buildWhen: (previous, current) => current is! EventSettingActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is EventSettingLoadingState) {
          return Shimmer.fromColors(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: double.infinity, height: 50),

                Container(width: double.infinity, height: 50),
                Container(width: double.infinity, height: 50),
                Container(width: double.infinity, height: 50),
              ],
            ),
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[500]!,
          );
        }
        if (state is EventSettingSuccessState) {
          return Scaffold(
            appBar: AppBar(
              // Move AppBar here
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              title: Text(
                "Calendar",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider(
                            create: (context) => EventSettingBloc(),
                            child: EventSetting(),
                          ),
                    ),
                  ),
              child: Icon(Icons.add, color: Colors.white, weight: 120),
            ),
            body: Column(
              children: [
                Expanded(child: CalenderController(events: state.events)),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class CalenderController extends StatefulWidget {
  const CalenderController({super.key, required this.events});
  final List<CalendarEventData> events;
  @override
  State<CalenderController> createState() => _CalenderControllerState();
}

class _CalenderControllerState extends State<CalenderController> {
  late EventController _eventController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _eventController = CalendarControllerProvider.of(context).controller;
    _eventController.addAll(widget.events);
    debugPrint("Done!!");
    return MonthView(
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        headerTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
