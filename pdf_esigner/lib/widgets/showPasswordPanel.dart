import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_esigner/repos/esigner.dart';

class PasswordPanel extends StatefulWidget {
  final Esigner esigner;
  const PasswordPanel({super.key, required this.esigner});

  @override
  State<PasswordPanel> createState() => _PasswordPanelState();
}

class _PasswordPanelState extends State<PasswordPanel> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigning = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 400), // Ensuring good UI on web
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildPasswordInput(),
              if (_isSigning) const SizedBox(height: 16),
              if (_isSigning) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCancelButton(context),
                  _buildEnterButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Password Input Field with Visibility Toggle
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
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }

  // Cancel Button
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: _isSigning ? null : () => Navigator.of(context).pop(),
      style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
    );
  }

  // Enter Button - Handles Password Submission
  Widget _buildEnterButton(BuildContext context) {
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

    setState(() {
      _isSigning = true;
    });

    try {
      bool success =
          await widget.esigner.signByPfx(_passwordController.text.trim());
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF signed successfully!')),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
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
