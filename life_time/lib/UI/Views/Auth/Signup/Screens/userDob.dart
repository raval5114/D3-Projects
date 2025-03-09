import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_time/Data/Utils/colorGradiants.dart';
import 'package:life_time/UI/Views/Auth/Signin/bloc/signin_bloc.dart';
import 'package:life_time/UI/Views/Auth/Signup/Widgets/userDobSection.dart';

class UserDob extends StatelessWidget {
  const UserDob({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: authGradiants),
        child: BlocProvider(
          create: (context) => SigninBloc(),
          child: const Center(child: UserDobSection()),
        ),
      ),
    );
  }
}
