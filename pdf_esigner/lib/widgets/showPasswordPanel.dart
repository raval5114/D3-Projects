import 'package:flutter/material.dart';
import 'package:pdf_esigner/repos/esigner.dart';

class PasswordPanel extends StatefulWidget {
  final Esigner esigner;
  const PasswordPanel({super.key, required this.esigner});

  @override
  State<PasswordPanel> createState() => _PasswordPanelState();
}

class _PasswordPanelState extends State<PasswordPanel> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigning = false; // Tracks if signing is in progress
  bool _obscureText = true; // Tracks password visibility

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Password:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPasswordInput(),
          if (_isSigning) ...[
            SizedBox(height: 16),
            CircularProgressIndicator(), // Loader when signing is in progress
          ],
        ],
      ),
      actions: [
        _buildCancelButton(context),
        _buildEnterButton(context),
      ],
    );
  }

  // Password input field with suffix for toggling visibility
  Widget _buildPasswordInput() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText, // Hide or show the text based on _obscureText
      decoration: InputDecoration(
        hintText: 'Enter your password',
        border: OutlineInputBorder(),
        suffix: InkWell(
          onTap: _togglePasswordVisibility, // Toggle password visibility on tap
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey, // Icon color
          ),
        ),
      ),
    );
  }

  // Toggle the visibility of the password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle the obscureText value
    });
  }

  // Cancel button for dialog
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.purpleAccent),
      onPressed: _isSigning
          ? null
          : () {
              Navigator.of(context).pop(); // Close the dialog
            },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Enter button to confirm password and sign
  Widget _buildEnterButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.purpleAccent),
      onPressed: _isSigning
          ? null
          : () async {
              if (_passwordController.text.isEmpty) {
                _showErrorDialog(context, "Password cannot be empty.");
                return;
              }

              setState(() {
                _isSigning = true; // Set signing state to true
              });

              try {
                // Attempt to sign the PDF with the entered password
                bool success = await widget.esigner
                    .signByPfx(_passwordController.text.trim());
                if (success) {
                  Navigator.of(context).pop(); // Automatically close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF signed successfully!')),
                  );
                }
              } catch (e) {
                // Show error dialog if signing fails
                _showErrorDialog(context, e.toString());
              } finally {
                setState(() {
                  _isSigning = false; // Reset signing state
                });
              }
            },
      child: Text(
        'ENTER',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Display error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
