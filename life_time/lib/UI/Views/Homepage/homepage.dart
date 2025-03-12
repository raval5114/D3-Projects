import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Calender/calender.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Home/home.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Notes/notes.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Settings/setting.dart';
import 'package:life_time/UI/Views/OtherViews/EventSettingScreen/bloc/event_setting_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itmes = [
      Homepage(),
      BlocProvider(create: (context) => EventSettingBloc(), child: Calender()),
      Notes(),
      Settings(),
    ];
    return Scaffold(
      body: itmes[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calender",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey[200],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purpleAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
