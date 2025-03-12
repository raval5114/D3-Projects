import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingOptionsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailing;
  final VoidCallback onTap;

  const SettingOptionsTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            leading: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            trailing:
                trailing != null
                    ? Text(
                      trailing!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
