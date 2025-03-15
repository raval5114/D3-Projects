import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifetime/Data/utils/colorGradiants.dart';
import 'package:lifetime/UI/Views/Auth/Signin/Widgets/signinSection.dart';
import 'package:lifetime/UI/Views/Auth/Signin/bloc/signin_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: authGradiants),
        child: Center(
          child: BlocProvider(
            create: (context) => SigninBloc(),
            child: SignInSection(),
          ),
        ),
      ),
    );
  }
}
