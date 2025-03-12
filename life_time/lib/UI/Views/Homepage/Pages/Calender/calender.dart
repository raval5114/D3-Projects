import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/UI/Views/OtherViews/EventSettingScreen/EventingSetting.dart';
import 'package:life_time/UI/Views/OtherViews/EventSettingScreen/bloc/event_setting_bloc.dart';

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
  const CalenderSection({super.key});

  @override
  State<CalenderSection> createState() => _CalenderSectionState();
}

class _CalenderSectionState extends State<CalenderSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Move AppBar here
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
            () => Navigator.pushReplacement(
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
      body: Column(children: [Expanded(child: CalenderController())]),
    );
  }
}

class CalenderController extends StatefulWidget {
  const CalenderController({super.key});

  @override
  State<CalenderController> createState() => _CalenderControllerState();
}

class _CalenderControllerState extends State<CalenderController> {
  @override
  Widget build(BuildContext context) {
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
