import 'package:flutter/material.dart';
import 'package:life_time/Data/Utils/colorGradiants.dart';
import 'package:life_time/UI/Views/Auth/Signup/Widgets/signupSection.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: authGradiants),
        child: Center(child: SignUpSection()),
      ),
    );
  }
}
