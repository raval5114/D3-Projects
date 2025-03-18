import 'package:flutter/material.dart';

class JourneyHistory extends StatefulWidget {
  const JourneyHistory({super.key});

  @override
  State<JourneyHistory> createState() => _JourneyHistoryState();
}

class _JourneyHistoryState extends State<JourneyHistory> {
  String? selectedVehicle;
  DateTime? fromDate, toDate;
  TimeOfDay? fromTime, toTime;

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isFromTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isFromTime) {
          fromTime = pickedTime;
        } else {
          toTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedVehicle,
                hint: const Text("Select Vehicle"),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value;
                  });
                },
                items:
                    ["Car", "Bike", "Truck"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // From Section
          const Text("From", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _dateTimePicker(context, true, true),
              const SizedBox(width: 8),
              _dateTimePicker(context, true, false),
            ],
          ),

          const SizedBox(height: 16),

          // To Section
          const Text("To", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _dateTimePicker(context, false, true),
              const SizedBox(width: 8),
              _dateTimePicker(context, false, false),
            ],
          ),

          const SizedBox(height: 24),

          // Show Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Show", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTimePicker(BuildContext context, bool isFrom, bool isDate) {
    return Expanded(
      child: GestureDetector(
        onTap:
            () =>
                isDate
                    ? _pickDate(context, isFrom)
                    : _pickTime(context, isFrom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDate
                    ? (isFrom
                            ? fromDate?.toString().split(" ")[0]
                            : toDate?.toString().split(" ")[0]) ??
                        "Pick Date"
                    : (isFrom
                            ? fromTime?.format(context)
                            : toTime?.format(context)) ??
                        "Pick Time",
                style: const TextStyle(color: Colors.black54),
              ),
              Icon(
                isDate ? Icons.calendar_month : Icons.access_time,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
