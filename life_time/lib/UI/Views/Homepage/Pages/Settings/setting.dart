import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/Data/Models/User.dart';
import 'package:life_time/UI/Views/Auth/Signin/repos/signin.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Settings/widgets/src/settingTile.dart';
import 'package:life_time/UI/Views/OtherViews/SetLifeExpentancyScreen/setLifeExpentancyScreen.dart';
import 'package:life_time/UI/Views/SpalashScreen/splash_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: SettingSection());
  }
}

class SettingSection extends StatefulWidget {
  const SettingSection({super.key});

  @override
  State<SettingSection> createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  void logout() {
    Signin signin = Signin();
    signin.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  /// **Shows a confirmation dialog before logging out**
  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                logout(); // Call the logout function
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String initials =
        (userModel.firstName.isNotEmpty && userModel.lastName.isNotEmpty)
            ? "${userModel.firstName[0].toUpperCase()}${userModel.lastName[0].toUpperCase()}"
            : "U"; // Default to 'U' if name is unavailable

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 4, // Soft neumorphic shadow effect
          shadowColor: Colors.black.withOpacity(0.2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Smooth rounded bottom
            ),
          ),
          title: Text(
            "Settings",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Ensures contrast
            ),
          ),
          centerTitle: true,
        ),
        const SizedBox(height: 40),
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            initials,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "${userModel.firstName} ${userModel.lastName}",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),
        SettingOptionsTile(
          onTap: () => debugPrint("yes its working"),
          title: "Set Password",
          icon: Icons.lock_rounded,
          trailing: '',
        ),

        SettingOptionsTile(
          icon: Icons.heat_pump_rounded,
          title: "Set Life Expentency",
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SetLifeExpectancyScreen(),
                ),
              ),
          trailing: userModel.lifeExpectancyYears,
        ),

        SettingOptionsTile(
          onTap: () => showLogoutDialog(),
          title: "Log out",
          icon: Icons.logout,
          trailing: '',
        ),
      ],
    );
  }
}
