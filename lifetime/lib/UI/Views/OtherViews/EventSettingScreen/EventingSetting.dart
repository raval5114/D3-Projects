import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifetime/UI/Views/OtherViews/EventSettingScreen/bloc/event_setting_bloc.dart';

class EventSetting extends StatefulWidget {
  const EventSetting({super.key});

  @override
  State<EventSetting> createState() => _EventSettingState();
}

class _EventSettingState extends State<EventSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Create New Event",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: const EventSettingComponent(),
    );
  }
}

class EventSettingComponent extends StatefulWidget {
  const EventSettingComponent({super.key});

  @override
  State<EventSettingComponent> createState() => _EventSettingComponentState();
}

class _EventSettingComponentState extends State<EventSettingComponent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  final EventSettingBloc bloc = EventSettingBloc();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Color _selectedColor = Colors.blue;

  /// Function to pick a date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      });
    }
  }

  /// Function to pick a time (Start or End)
  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
          _startTimeController.text = _startTime!.format(context);
        } else {
          _endTime = pickedTime;
          _endTimeController.text = _endTime!.format(context);
        }
      });
    }
  }

  /// Validate and submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform event creation logic
      print("Event Added: ${_titleController.text}");
      bloc.add(
        EventSettingEventAddingEvent(
          eventTitle: _titleController.text.toString(),
          eventDate: _dateController.text.toString(),
          eventStartingTime: _startTime.toString(),
          eventEndingTime: _endTime.toString(),
          eventDiscripion: _descriptionController.text.toString(),
          eventColor: _selectedColor == Colors.blue ? "blue" : "red",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventSettingBloc, EventSettingState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is EventSettingActionState,
      buildWhen: (previous, current) => current is! EventSettingActionState,
      listener: (context, state) {
        if (state is EventSettingEventAddedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event successfully created!")),
          );
        }
        if (state is EventSettingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error:${state.errorMessage}")),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Event Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Event title is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Select Date
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select a date";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Start & End Time
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startTimeController,
                            decoration: const InputDecoration(
                              labelText: "Start Time",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Start time is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _endTimeController,
                            decoration: const InputDecoration(
                              labelText: "End Time",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "End time is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Event Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: "Event Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Event description is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Event Color Picker
                Row(
                  children: [
                    const Text("Event Color:"),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor =
                              _selectedColor == Colors.blue
                                  ? Colors.red
                                  : Colors.blue;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: _selectedColor,
                        radius: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Add Event Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      "Add Event",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
