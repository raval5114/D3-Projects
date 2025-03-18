import 'package:flutter/material.dart';

class ProfileSectionComponent extends StatelessWidget {
  const ProfileSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 40, child: Icon(Icons.person)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Siddhartha Pathak",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Designation - Customer ID",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSectionComponent(),
                      ),
                    ),
                child: const Icon(Icons.edit, color: Colors.orange),
              ),
            ],
          ),
        ),
        const Divider(),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                ProfileDetailRow(
                  title: "Email",
                  value: "location_tracker01@gmail.com",
                ),
                ProfileDetailRow(title: "Contact", value: "+91 0000 00000"),
                ProfileDetailRow(
                  title: "Emergency Contact",
                  value: "+91 0000 00000",
                ),
                ProfileDetailRow(title: "Aadhar Id", value: "XXXX XXXX XXXX"),
                ProfileDetailRow(
                  title: "Address",
                  value:
                      "B-202, Big Building Apartment,\nNear Central Railway Station, Agra",
                ),
                ProfileDetailRow(title: "Pin Code", value: "XXX XXX"),
                ProfileDetailRow(title: "State", value: "Gujarat"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          const Divider(),
        ],
      ),
    );
  }
}
