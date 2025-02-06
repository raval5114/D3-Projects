import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'dart:io';
import 'package:pdf_esigner/repos/esigner.dart';

class Options extends StatefulWidget {
  final Esigner esigner;
  final VoidCallback onClose;

  const Options({Key? key, required this.onClose, required this.esigner})
      : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Variable to store the selected PFX file
  File? _selectedPfxFile;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: ANIMATION_SPEED,
    );
    // Define the scale animation
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Common widget for option items to reduce repetition
  Widget _buildOptionItem(String label, VoidCallback onTap,
      {Color color = Colors.purpleAccent}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      right: 20,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Signature Options",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // PFX File Option
                _buildOptionItem(
                  "Pfx File",
                  () async {
                    await widget.esigner.pickFile('pfx');
                    setState(() {
                      _selectedPfxFile = widget.esigner.pfxFile;
                    });
                  },
                ),
                // Display selected PFX file if available
                if (_selectedPfxFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Selected PFX: ${_selectedPfxFile!.path.split('/').last}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                // Handwritten Option
                _buildOptionItem(
                  "Handwritten",
                  () {
                    print("Handwritten option selected");
                  },
                ),
                const SizedBox(height: 10),
                // Close Option
                _buildOptionItem(
                  "Close",
                  () {
                    // Reverse the animation before closing
                    _animationController.reverse().then((_) {
                      widget.onClose();
                    });
                  },
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
