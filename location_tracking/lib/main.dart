import 'package:flutter/material.dart';
import 'package:location_tracking/Views/Homepage/homepage.dart';
import 'package:location_tracking/config/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CONFIG_TITLE,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,

          primary: Color(0xFFF37021),
          onPrimary: Colors.white,

          secondary: Color(0xFF333333),
          onSecondary: Colors.white,

          surface: Color(0xFFF5F5F5),
          onSurface: Colors.black,

          error: Color(0xFFD32F2F),
          onError: Colors.white,

          tertiary: Color(0xFF007AFF),
          onTertiary: Colors.white,
        ),

        primaryColor: Color(0xFFF37021), // Keep primary color
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF37021),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFF37021),
          unselectedItemColor: Color(0xFF333333),
        ),

        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Color(0xFF333333)),
        ),

        useMaterial3: true, // Enable Material 3 design
      ),
      home: MyHomePage(),
    );
  }
}
