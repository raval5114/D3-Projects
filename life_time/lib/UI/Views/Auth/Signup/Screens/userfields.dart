import 'package:flutter/material.dart';
import 'package:life_time/Data/Utils/colorGradiants.dart';
import 'package:life_time/UI/Views/Auth/Signup/Widgets/userfeildsSection.dart';

class UserField extends StatefulWidget {
  const UserField({super.key});

  @override
  State<UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: authGradiants),
        child: Center(child: UserFieldSection()),
      ),
    );
  }
}
