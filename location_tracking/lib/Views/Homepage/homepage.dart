import 'package:flutter/material.dart';
import 'package:location_tracking/Views/Homepage/Widgets/appBar.dart';
import 'package:location_tracking/Views/Homepage/Widgets/drawer.dart';
import 'package:location_tracking/Views/Homepage/pages/dashboard/dashboard.dart';
import 'package:location_tracking/Views/Homepage/pages/distance_travelled/distance_travelled.dart';
import 'package:location_tracking/Views/Homepage/pages/journey_history/journey_history.dart';
import 'package:location_tracking/Views/Homepage/pages/live_tracing/live_tracing.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<int, String> _appBarTitle = {
    0: "Dashboard",
    1: "Live Tracking",
    2: "Journey History",
    3: "Distance Travelled",
  };

  List<Widget> pages = [
    DashBoard(),
    LiveTracing(),
    JourneyHistory(),
    DistranceTavelled(),
  ];

  int selectedPage = 0;

  void onPageChanges(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(pageTitle: _appBarTitle[selectedPage]!),
      body: pages[selectedPage], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: onPageChanges,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFF37021), // Active color
        unselectedItemColor: Colors.grey, // Inactive color
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
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
            label: "Distance Travelled",
          ),
        ],
      ),
    );
  }
}
