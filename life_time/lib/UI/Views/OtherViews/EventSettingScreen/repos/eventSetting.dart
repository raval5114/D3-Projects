import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_time/Data/Models/User.dart';

class EventSettingRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addingEvents({
    required String eventTitle,
    required String eventDate,
    required String eventStartTime,
    required String eventEndTime,
    required String eventDescription,
    required String eventColor,
  }) async {
    try {
      // Get the current user's ID
      String userId = userModel.uid;

      // Reference to the 'events' collection
      DocumentReference userEventDoc = _firestore
          .collection("events")
          .doc(userId);

      // Event data to be added
      Map<String, dynamic> newEvent = {
        "title": eventTitle,
        "date": eventDate,
        "startTime": eventStartTime,
        "endTime": eventEndTime,
        "description": eventDescription,
        "color": eventColor, // For sorting
      };

      // Fetch existing document
      DocumentSnapshot docSnapshot = await userEventDoc.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        // If user document exists, retrieve the existing events list
        List<dynamic> existingEvents =
            (docSnapshot.data() as Map<String, dynamic>)["events"] ?? [];

        // Append new event
        existingEvents.add(newEvent);

        // Update Firestore with the new events list
        await userEventDoc.update({"events": existingEvents});
      } else {
        // If user document doesn't exist, create a new one
        await userEventDoc.set({
          "uiid": userId,
          "events": [newEvent],
        });
      }

      print("Event added successfully!");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<CalendarEventData> _loadEvent({
    required String startDate,
    required String title,
    required String eventDiscription,
    required String Color,
  }) async {
    DateFormat format = DateFormat("d/M/yyyy");
    DateTime parsedStartDate = format.parse(startDate);
    final event = CalendarEventData(
      date: parsedStartDate,
      event: eventDiscription,
      title: title,
      color: Color == "blue" ? Colors.blue : Colors.red,
    );

    return Future.value(event);
  }

  Future<List<CalendarEventData>> loadEvents() async {
    try {
      // Get current user ID
      String userId = _auth.currentUser!.uid;

      // Fetch the user's event document from Firestore
      DocumentSnapshot docSnapshot =
          await _firestore.collection("events").doc(userId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        List<dynamic> events =
            (docSnapshot.data() as Map<String, dynamic>)["events"] ?? [];

        // Convert Firestore events to CalendarEventData
        List<CalendarEventData> eventList = await Future.wait(
          events
              .map(
                (e) => _loadEvent(
                  title: e['title'],
                  eventDiscription: e['description'],
                  startDate: e['date'],
                  Color: e['color'],
                ),
              )
              .toList(), // Convert Iterable to List
        );

        return eventList;
      }

      return [];
    } catch (e) {
      throw Exception("Event Loading Error: $e");
    }
  }
}
