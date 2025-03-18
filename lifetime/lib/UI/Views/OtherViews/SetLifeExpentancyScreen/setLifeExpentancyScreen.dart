import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifetime/Data/Models/User.dart';
import 'package:lifetime/UI/Views/Homepage/Pages/Home/home.dart';
import 'package:lifetime/UI/Views/Homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetLifeExpectancyScreen extends StatefulWidget {
  const SetLifeExpectancyScreen({super.key});

  @override
  State<SetLifeExpectancyScreen> createState() =>
      _SetLifeExpectancyScreenState();
}

class _SetLifeExpectancyScreenState extends State<SetLifeExpectancyScreen> {
  final TextEditingController _lifeExpectancyController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("Life expectancy updated successfully."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Future<void> setLifeExpectancy(String years, String uid) async {
    try {
      int? expectancy = int.tryParse(years);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (expectancy == null) {
        _showErrorDialog("Please enter a valid number.");
        return;
      }

      await _firestore.collection('users').doc(uid).set({
        'lifeExpectancy': expectancy, // Store as integer
      }, SetOptions(merge: true));

      setState(() {
        userModel.lifeExpectancyYears = expectancy.toString();
      });
      _showSuccessDialog();
      //a dailog box shows up saying years are changed successfully
    } catch (e) {
      throw Exception("Life Expectancy Setting Error:${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    void onSubmit() {
      setLifeExpectancy(
        _lifeExpectancyController.text.toLowerCase(),
        userModel.uid,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              ),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Set Life Expectancy",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your expected lifespan:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lifeExpectancyController,
              decoration: InputDecoration(
                hintText: "Enter years (in numbers)",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: colorScheme.surface.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.secondary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
