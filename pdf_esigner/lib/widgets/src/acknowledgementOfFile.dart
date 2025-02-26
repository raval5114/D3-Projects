import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';

class PfxAcknowledgment extends StatelessWidget {
  final String? pfxFileName;

  const PfxAcknowledgment({super.key, required this.pfxFileName});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ANIMATION_SPEED,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            pfxFileName != null ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: pfxFileName != null
                ? Colors.green.shade400
                : Colors.red.shade400),
      ),
      child: Row(
        children: [
          Icon(pfxFileName != null ? Icons.verified : Icons.warning,
              color: pfxFileName != null ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Text(
            pfxFileName ?? "No PFX file selected",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: pfxFileName != null
                  ? Colors.green.shade800
                  : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
