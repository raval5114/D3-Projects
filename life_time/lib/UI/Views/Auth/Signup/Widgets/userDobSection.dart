import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_time/Data/Models/RegisterUser.dart';
import 'package:life_time/UI/Views/Auth/Signin/Signin.dart';
import 'package:life_time/UI/Views/Auth/Signin/repos/signin.dart';
import 'package:life_time/UI/Views/Auth/Signup/Screens/signup.dart';
import 'package:life_time/UI/Views/Auth/Signup/bloc/signup_bloc.dart';
import 'package:life_time/UI/Views/SpalashScreen/splash_screen.dart';

class UserDobSection extends StatefulWidget {
  const UserDobSection({super.key});

  @override
  State<UserDobSection> createState() => _UserDobSectionState();
}

class _UserDobSectionState extends State<UserDobSection> {
  DateTime? _selectedDate;
  String? _errorMessage;
  bool _isLoading = false;
  SignupBloc bloc = SignupBloc();
  void _showDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text(
        "Set your Birthday",
        style: TextStyle(
          fontSize: 20, // Increased font size for better visibility
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple, // Enhanced color for contrast
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: _selectedDate ?? DateTime(1996, 10, 22),
      maxDateTime: DateTime(2010),
      minDateTime: DateTime(1980),
      pickerTextStyle: const TextStyle(
        color: Colors.deepPurpleAccent,
        fontSize: 18, // Slightly larger for readability
        fontWeight: FontWeight.bold,
      ),
      onChange: (date) {
        setState(() {
          _selectedDate = date;
          _errorMessage = null; // Clear error message when date is selected
        });
      },
      onSubmit: (date) {
        setState(() {
          _selectedDate = date;
          _errorMessage = null; // Clear error message when date is selected
        });
      },
    ).show(context);
  }

  void _handleSubmit() {
    if (_selectedDate == null) {
      setState(() {
        _isLoading = true;
        _errorMessage = "Please select your date of birth.";
      });
    } else {
      registerUser.dob = _selectedDate!;
      bloc.add(
        SignupEvent(
          email: registerUser.email,
          password: registerUser.password,
          firstName: registerUser.firstName,
          lastName: registerUser.lastName,
          username: registerUser.username,
          dob: registerUser.dob.toIso8601String(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      bloc: bloc,
      listenWhen: (previous, current) => current is SignupActionState,
      buildWhen: (previous, current) => current is! SignupActionState,
      listener: (context, state) {
        if (state is SignupLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is SignupSuccessState) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        } else if (state is SignupErrorState) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12, // Slightly more shadow for depth
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Your Date of Birth",
                      style: TextStyle(
                        fontSize: 22, // Slightly larger headline
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _showDatePicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 22,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.deepPurple[50],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                  : "Tap to select your birthdate",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_selectedDate != null)
                      Text(
                        "You were born on: ${_selectedDate!.day} ${_getMonthName(_selectedDate!.month)} ${_selectedDate!.year}",
                        style: const TextStyle(
                          fontSize: 18, // Slightly larger for emphasis
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSubmit,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                        : const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
