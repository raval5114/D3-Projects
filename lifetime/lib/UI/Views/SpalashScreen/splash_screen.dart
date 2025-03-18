import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifetime/UI/Views/Auth/Signin/Signin.dart';
import 'package:lifetime/UI/Views/Auth/Signin/bloc/signin_bloc.dart';
import 'package:lifetime/UI/Views/Auth/Signin/repos/signin.dart';
import 'package:lifetime/UI/Views/Homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  final SigninBloc _signinBloc = SigninBloc();
  @override
  void initState() {
    super.initState();
    // Start the animation
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
      initialEvent();
    });
  }

  void initialEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == null &&
        prefs.getString('password') == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } else {
      _signinBloc.add(
        SigninEvent(
          email: prefs.getString('email')!,
          password: prefs.getString('password')!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SigninState>(
      bloc: _signinBloc,
      listener: (context, state) {
        if (state is SigninSuccessState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
        if (state is SigninLoadingState) {}
        if (state is SigninErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.amber, // Primary color
          body: Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple, // Secondary color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cake_rounded, // Birthday-related icon
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "LifeTime",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Track your journey from birth to beyond!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
