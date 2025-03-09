import 'package:flutter/material.dart';

class SettingOptionsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String trailing;
  final VoidCallback onTap;

  const SettingOptionsTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.grey[200],
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing != null ? Text(trailing) : null,
      ),
    );
  }
}
