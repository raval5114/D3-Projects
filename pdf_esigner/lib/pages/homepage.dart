import 'package:flutter/material.dart';
import 'package:pdf_esigner/repos/esigner.dart';
import 'package:pdf_esigner/widgets/options.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Esigner esigner = Esigner();
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

  void _showOverlay() {
    if (_overlayEntry != null) return; // Prevent duplicate overlays
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!); // Correct usage of BuildContext
  }

  // Remove the overlay
  void _removeOverlay() {
    if (_overlayEntry == null) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Function to show a Snackbar with the result of the signing process
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf e-Signer"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PDF File Name Container
            if (esigner.pdfFile != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                  'PDF File Added: ${esigner.pdfFileName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // PFX File Name Container
            if (esigner.pfxFile != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                  'PFX File Added: ${esigner.pfxFileName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 40),
            // Add PDF Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
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
                onTap: () async {
                  await esigner.pickFile('pdf');
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Add PDF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Sign and Save Button
            ElevatedButton(
              onPressed: () async {
                try {
                  bool success = await esigner.signByPfx("1234567890");
                  if (success) {
                    _showSnackBar("PDF signed and saved successfully.");
                  } else {
                    _showSnackBar("Failed to sign the PDF.");
                  }
                } catch (e) {
                  // Handle error if needed
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                elevation: 5,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Sign and Save PDF",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
