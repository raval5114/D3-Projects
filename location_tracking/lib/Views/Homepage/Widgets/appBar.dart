import 'package:flutter/material.dart';
import 'package:location_tracking/Views/Homepage/pages/notificationPage/eventAndNotificationPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  const CustomAppBar({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(pageTitle),
      backgroundColor: Color(0xFFF37021), // Matching theme color
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Eventandnotificationpage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
