import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:life_time/UI/Views/SpalashScreen/splash_screen.dart';
import 'package:life_time/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber[400],
        scaffoldBackgroundColor: Color(
          0xFFE0E0E0,
        ), // Soft background for neumorphism
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.amber[400]!,
          secondary: Colors.purple[500]!,
          surface: Color(0xFFF5F5F5), // Soft surface color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
