import 'package:flutter/material.dart';
import 'package:pdf_esigner/repos/esigner.dart';
import 'package:pdf_esigner/widgets/options.dart';
import 'package:pdf_esigner/widgets/showPasswordPanel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Esigner esigner = Esigner();
  OverlayEntry? _overlayEntry;

  // Function to create the overlay entry
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Options(
        onClose: _removeOverlay,
        esigner: esigner,
      ),
    );
  }

  // Display the overlay
  void _showOverlay() {
    if (_overlayEntry != null) return; // Prevent duplicate overlays
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Remove the overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Function to show a SnackBar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // Widget for displaying file details
  Widget _buildFileInfo(String label, String fileName, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        '$label: $fileName',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Button widget to avoid repetition
  Widget _buildButton(String label, VoidCallback onTap, Color backgroundColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF e-Signer"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // PDF File Details
                if (esigner.pdfFile != null)
                  _buildFileInfo(
                    'PDF File Added',
                    esigner.pdfFileName!,
                    Colors.purpleAccent,
                  ),
                // PFX File Details
                if (esigner.pfxFile != null)
                  _buildFileInfo(
                    'PFX File Added',
                    esigner.pfxFileName!,
                    Colors.deepPurple,
                  ),
                const SizedBox(height: 40),
                // Add PDF Button
                _buildButton(
                  "Add PDF",
                  () async {
                    await esigner.pickFile('pdf');
                    setState(() {});
                  },
                  Colors.purpleAccent,
                ),
                const SizedBox(height: 20),
                // Sign and Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (esigner.pfxFile == null) {
                      _showSnackBar("No PFX file selected for signing.");
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => PasswordPanel(esigner: esigner),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Sign and Save PDF",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.purpleAccent,
          onPressed: () {
            if (_overlayEntry == null) {
              _showOverlay();
            } else {
              _removeOverlay();
            }
            setState(() {}); // Ensure UI updates when overlay state changes
          },
          child: Icon(
            _overlayEntry == null ? Icons.edit : Icons.close,
            color: Colors.white,
          ),
        ));
  }
}
