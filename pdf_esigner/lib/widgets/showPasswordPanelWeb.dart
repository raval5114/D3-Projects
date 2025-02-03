import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_esigner/repos/esigner.dart';

class PasswordPanelWeb {
  final BuildContext context;
  final Esigner esigner;
  late OverlayEntry _overlayEntry;
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigning = false;
  bool _obscureText = true;

  PasswordPanelWeb({required this.context, required this.esigner}) {
    _overlayEntry = _createOverlayEntry();
  }
  void showPasswordPanel() {
    PasswordPanelWeb passwordPanel = PasswordPanelWeb(
      context: context,
      esigner: esigner,
    );
    passwordPanel.showOverlay();
  }

  // Function to create the overlay entry
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background Overlay to dismiss on tap
          Positioned.fill(
            child: GestureDetector(
              onTap: removeOverlay,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // Password Panel UI
          Center(
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter Password',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      _buildPasswordInput(),
                      if (_isSigning) const SizedBox(height: 16),
                      if (_isSigning) const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCancelButton(),
                          _buildEnterButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display the overlay
  void showOverlay() {
    Overlay.of(context).insert(_overlayEntry);
  }

  // Remove the overlay
  void removeOverlay() {
    _overlayEntry.remove();
  }

  // Password Input Field
  Widget _buildPasswordInput() {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          _handleSign();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TextField(
        controller: _passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              _obscureText = !_obscureText;
              _updateOverlay();
            },
          ),
        ),
      ),
    );
  }

  // Cancel Button
  Widget _buildCancelButton() {
    return TextButton(
      onPressed: _isSigning ? null : removeOverlay,
      style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
    );
  }

  // Enter Button - Handles Password Submission
  Widget _buildEnterButton() {
    return TextButton(
      onPressed: _isSigning ? null : _handleSign,
      style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
      child: const Text('ENTER', style: TextStyle(color: Colors.white)),
    );
  }

  // Handles Signing Logic
  Future<void> _handleSign() async {
    FocusScope.of(context).unfocus(); // Hide keyboard and remove focus

    if (_passwordController.text.isEmpty) {
      _showErrorDialog("Password cannot be empty.");
      return;
    }

    _isSigning = true;
    _updateOverlay(); // Refresh UI

    try {
      bool success = await esigner.signByPfx(_passwordController.text.trim());
      if (success) {
        removeOverlay();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF signed successfully!')),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      _isSigning = false;
      _updateOverlay(); // Refresh UI
    }
  }

  // Update Overlay UI
  void _updateOverlay() {
    _overlayEntry.markNeedsBuild();
  }

  // Displays Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
