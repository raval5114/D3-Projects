import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'package:pdf_esigner/repos/esigner.dart';
import 'package:pdf_esigner/widgets/options.dart';
import 'dart:js_interop';

@JS('showPasswordPrompt')
external String? showPasswordPrompt();

class WebHomepage extends StatefulWidget {
  const WebHomepage({super.key});

  @override
  State<WebHomepage> createState() => _WebHomepageState();
}

class _WebHomepageState extends State<WebHomepage> {
  bool isDownloading = false;
  final Esigner esigner = Esigner();
  OverlayEntry? _overlayEntry;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: PRIMARY_COLOR,
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    //for signing
    void showBrowserPasswordDialog() async {
      String? password = showPasswordPrompt(); // Call JS function

      if (password != null) {
        setState(() {
          isDownloading = true;
        });

        bool success = await esigner.signByPfx(password);

        if (success) {
          esigner.downloadPdf_ForWeb();
          _showSnackBar("Signed Successfully");
        } else {
          _showSnackBar("Signing failed. Please check the password.");
        }
      } else {
        debugPrint("Password input was canceled.");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF e-Signer Web"),
        centerTitle: true,
        backgroundColor: PRIMARY_COLOR,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: SECOUNDARY_COLOR,
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
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (esigner.pdfBytes != null)
                _buildFileInfo(
                    "PDF File Added", esigner.pdfFileName!, SECOUNDARY_COLOR),
              if (esigner.pfxBytes != null)
                _buildFileInfo(
                    "PFX File Added", esigner.pfxFileName!, Colors.deepPurple),
              const SizedBox(height: 30),
              _buildButton("Add PDF", () async {
                await esigner.pickFile('pdf');
                setState(() {});
              }, SECOUNDARY_COLOR),
              const SizedBox(height: 20),
              _buildButton("Sign and Save PDF", () async {
                if (esigner.pfxBytes == null) {
                  _showSnackBar("No PFX file selected for signing.");
                  return;
                }
                showBrowserPasswordDialog();
              }, PRIMARY_COLOR),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfo(String label, String fileName, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          Flexible(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap, Color backgroundColor) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 5,
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
