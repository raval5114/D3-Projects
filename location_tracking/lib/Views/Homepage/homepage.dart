import 'package:flutter/material.dart';
import 'package:location_tracking/Data/Utils/navigatorindex.dart';
import 'package:location_tracking/Views/Homepage/Widgets/drawer.dart';
import 'package:location_tracking/Views/Homepage/pages/notificationPage/eventAndNotificationPage.dart';
import 'package:location_tracking/Views/Homepage/pages/dashboard/dashboard.dart';
import 'package:location_tracking/Views/Homepage/pages/distance_travelled/distance_travelled.dart';
import 'package:location_tracking/Views/Homepage/pages/journey_history/journey_history.dart';
import 'package:location_tracking/Views/Homepage/pages/live_tracing/live_tracing.dart';
import 'package:location_tracking/Views/Homepage/pages/profileSection/profileSection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<int, String> _appBarTitle = {
    0: "Dashboard",
    1: "Live Tracking",
    2: "Journey History",
    3: "Distance Travelled",
    4: "Event & Notification",
    5: "Profile",
  };

  final List<Widget> pages = const [
    DashBoard(),
    LiveTracing(),
    JourneyHistory(),
    DistanceTravelled(),
    Eventandnotificationpage(),
    ProfileSectionComponent(),
  ];

  void onPageChanges(int index) {
    setState(() {
      NavigatorIndex().index = index; // Update global index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        onProfileTap: () {
          onPageChanges(5); // Navigate to Profile
        },
      ),
      appBar: AppBar(
        title: Text(_appBarTitle[NavigatorIndex().index]!),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              onPageChanges(4); // Switch to Notifications
            },
          ),
        ],
      ),
      body: pages[NavigatorIndex().index], // Use global index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            NavigatorIndex().index > 3
                ? 0
                : NavigatorIndex().index, // Fix index errors
        onTap: onPageChanges,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF37021),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 24),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed, size: 24),
            label: "Live Tracking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 24),
            label: "Journey History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 24),
            label: "Distance",
          ),
        ],
      ),
    );
  }
}
