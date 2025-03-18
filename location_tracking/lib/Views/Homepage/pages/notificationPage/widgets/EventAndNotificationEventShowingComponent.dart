import 'package:flutter/material.dart';
import 'package:location_tracking/Views/Homepage/pages/NotificationPage/widgets/src/eventTile.dart';

class EventAndNotificationPageEventShowingComponent extends StatefulWidget {
  final List<Map<String, dynamic>>? data; // Made nullable

  const EventAndNotificationPageEventShowingComponent({
    super.key,
    required this.data,
  });

  @override
  State<EventAndNotificationPageEventShowingComponent> createState() =>
      _EventAndNotificationPageEventShowingComponentState();
}

class _EventAndNotificationPageEventShowingComponentState
    extends State<EventAndNotificationPageEventShowingComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.data == null || widget.data!.isEmpty) {
      return Center(
        child: Text(
          "No events are being shown",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 16),
        itemCount: widget.data!.length,
        itemBuilder: (context, index) {
          var item = widget.data![index];

          if (item['date'] == null) {
            return SizedBox();
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: EventTile(
              vehicleName: item['vehicleName'],
              date: item['date'],
              ignitionState: item['ignitionState'],
              speed: item['speed'],
              location: item['location'],
            ),
          );
        },
      ),
    );
  }
}
