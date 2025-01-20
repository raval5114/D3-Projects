import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:pdf_esigner/widgets/options.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  OverlayEntry? _overlayEntry;
  File? _selectedFile; // Variable to store the selected file

  // Function to create the overlay entry
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Options(
        onClose: _removeOverlay,
      ),
    );
  }

  // Show the overlay
  void _showOverlay() {
    if (_overlayEntry != null) return; // Prevent duplicate overlays
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Remove the overlay
  void _removeOverlay() {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // File picker function
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files
    );

    if (result != null) {
      File file = File(result.files.single.path!); // Get the file
      setState(() {
        _selectedFile = file;
      });
      print("Selected file: ${file.path}");
    } else {
      // User canceled the picker
      print("File picking canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf e-Signer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: _pickFile, // Call the file picker
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Add Pdf",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_selectedFile != null)
              Text(
                "Selected File: ${_selectedFile!.path.split('/').last}",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          if (_overlayEntry == null) {
            _showOverlay();
            setState(() {});
          } else {
            _removeOverlay();
            setState(() {});
          }
        },
        child: Icon(
          _overlayEntry == null ? Icons.edit : Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
