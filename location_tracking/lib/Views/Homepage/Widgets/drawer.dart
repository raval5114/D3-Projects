import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isFeaturesExpanded = false;
  bool isMastersExpanded = false;
  bool isSettingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with User Profile & Circular Avatar
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Siddharth Pathak",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text(
              "Designation - Customer ID",
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(radius: 36, child: Icon(Icons.person)),
            ),
            decoration: BoxDecoration(color: Color(0xFFF37021)),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.home, "Home"),
                _buildExpandableItem(
                  Icons.layers,
                  "Features",
                  isFeaturesExpanded,
                  () {
                    setState(() {
                      isFeaturesExpanded = !isFeaturesExpanded;
                    });
                  },
                ),
                if (isFeaturesExpanded)
                  _buildSubMenu(["Feature 1", "Feature 2"]),

                _buildDrawerItem(Icons.bar_chart, "Reports"),

                _buildExpandableItem(
                  Icons.folder,
                  "Masters",
                  isMastersExpanded,
                  () {
                    setState(() {
                      isMastersExpanded = !isMastersExpanded;
                    });
                  },
                ),
                if (isMastersExpanded) _buildSubMenu(["Master 1", "Master 2"]),

                _buildDrawerItem(Icons.location_searching, "Locate Vehicle"),
                _buildDrawerItem(Icons.share_location, "Share Location"),
                _buildDrawerItem(Icons.directions_run, "Follow Me"),

                _buildExpandableItem(
                  Icons.settings,
                  "Settings",
                  isSettingsExpanded,
                  () {
                    setState(() {
                      isSettingsExpanded = !isSettingsExpanded;
                    });
                  },
                ),
                if (isSettingsExpanded) _buildSubMenu(["Profile", "Security"]),

                Divider(),
                _buildDrawerItem(Icons.help_outline, "Help & Support"),
                _buildDrawerItem(Icons.logout, "Logout", color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Standard Drawer Item
  Widget _buildDrawerItem(
    IconData icon,
    String title, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      onTap: () {},
    );
  }

  // Expandable Drawer Item
  Widget _buildExpandableItem(
    IconData icon,
    String title,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: Colors.black,
      ),
      onTap: onTap,
    );
  }

  // Submenu Items
  Widget _buildSubMenu(List<String> items) {
    return Column(
      children:
          items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: ListTile(
                    title: Text(item, style: const TextStyle(fontSize: 14)),
                    onTap: () {},
                  ),
                ),
              )
              .toList(),
    );
  }
}
