import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_time/Data/Models/User.dart';
import 'package:life_time/UI/Views/Homepage/Pages/Settings/widgets/src/settingTile.dart';

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
          onTap: () => debugPrint("yass its working"),
          trailing: userModel.lifeExpectancyYears,
        ),
        SettingOptionsTile(
          onTap: () => debugPrint("yass its working"),
          title: "Log out",
          icon: Icons.logout,
          trailing: '',
        ),
      ],
    );
  }
}
