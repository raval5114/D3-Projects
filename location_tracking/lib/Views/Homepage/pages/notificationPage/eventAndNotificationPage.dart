import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/Views/Homepage/Widgets/appBar.dart';
import 'package:location_tracking/Views/Homepage/Widgets/drawer.dart';
import 'package:location_tracking/Views/Homepage/pages/NotificationPage/bloc/notification_and_event_bloc.dart';
import 'package:location_tracking/Views/Homepage/pages/notificationPage/widgets/EventAndNotificationEventShowingComponent.dart';
import 'package:shimmer/shimmer.dart';

class Eventandnotificationpage extends StatelessWidget {
  const Eventandnotificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return EventAndNotificationPageComponent();
  }
}

class EventAndNotificationPageComponent extends StatefulWidget {
  const EventAndNotificationPageComponent({super.key});

  @override
  State<EventAndNotificationPageComponent> createState() =>
      _EventAndNotificationPageComponentState();
}

class _EventAndNotificationPageComponentState
    extends State<EventAndNotificationPageComponent> {
  String? selectedVehicle;
  DateTime? selectedDate;
  List<String> itemsList = ["Car", "Bike", "Truck"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: BlocProvider(
        create: (context) => NotificationAndEventBloc(),
        child: BlocBuilder<NotificationAndEventBloc, NotificationAndEventState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  children: [
                    // Vehicle Dropdown
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Select Vehicle"),
                            value: selectedVehicle,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVehicle = newValue;
                              });
                            },
                            items:
                                itemsList.map((String vehicle) {
                                  return DropdownMenuItem<String>(
                                    value: vehicle,
                                    child: Text(vehicle),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Date Picker
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate == null
                                    ? "Pick Date"
                                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              ),
                              Icon(Icons.calendar_today, color: Colors.orange),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Proceed Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF37021),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (selectedVehicle == null || selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please select both vehicle and date",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        context.read<NotificationAndEventBloc>().add(
                          NotificationAndEventPageEventCatchingEvent(
                            vechicleName: selectedVehicle!,
                            date: selectedDate.toString(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Proceed",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Bloc Listener & Builder
                BlocConsumer<
                  NotificationAndEventBloc,
                  NotificationAndEventState
                >(
                  listenWhen:
                      (previous, current) =>
                          current is NotificationAndEventActionState,
                  buildWhen:
                      (previous, current) =>
                          current is! NotificationAndEventActionState,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is NotificationAndEventLoadingState) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey[300]!,
                        child: Column(
                          children: List.generate(
                            5,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is NotificationAndEventSuccessState) {
                      return EventAndNotificationPageEventShowingComponent(
                        data: state.data,
                      );
                    }
                    return Container(child: Text("data"));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
