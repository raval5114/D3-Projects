import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final int noteId;
  final bool isChecked;
  final String title;
  final String discription;
  final DateTime deadLine;
  final VoidCallback ontap;
  const NoteTile({
    super.key,
    required this.noteId,
    required this.isChecked,
    required this.title,
    required this.discription,
    required this.deadLine,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: isChecked ? Colors.green.shade100 : Colors.red.shade100,
      ),
      child: ListTile(
        leading: Icon(
          isChecked ? Icons.check_circle : Icons.circle_outlined,
          color: isChecked ? Colors.green : Colors.red,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(discription),
        onTap: ontap,
      ),
    );
  }
}
