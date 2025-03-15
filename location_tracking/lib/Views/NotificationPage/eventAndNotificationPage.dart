import 'package:flutter/material.dart';
import 'package:location_tracking/Views/Homepage/Widgets/appBar.dart';
import 'package:location_tracking/Views/Homepage/Widgets/drawer.dart';

class Eventandnotificationpage extends StatelessWidget {
  const Eventandnotificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(pageTitle: 'Events & Notifications'),
      body: EventAndNotificationPageComponent(),
    );
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
      child: Column(
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
                      value: selectedVehicle, // FIXED
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
              onPressed: () {},
              child: Text(
                "Proceed",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
