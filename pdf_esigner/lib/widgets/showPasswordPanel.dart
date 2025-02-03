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
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isSigning = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: GestureDetector(
        // Add this to handle taps outside the TextField
        onTap: () => FocusScope.of(context).unfocus(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
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
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Focus(
      focusNode: _passwordFocusNode,
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
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: _isSigning
          ? null
          : () {
              _passwordFocusNode.unfocus();
              Navigator.pop(context);
            },
      style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildEnterButton(BuildContext context) {
    return TextButton(
      onPressed: _isSigning
          ? null
          : () {
              _passwordFocusNode.unfocus();
              _handleSign();
            },
      style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
      child: const Text('ENTER', style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _handleSign() async {
    FocusScope.of(context).unfocus(); // Remove focus globally

    if (_passwordController.text.isEmpty) {
      _showErrorDialog("Password cannot be empty.");
      return;
    }

    setState(() => _isSigning = true);

    try {
      final success =
          await widget.esigner.signByPfx(_passwordController.text.trim());
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF signed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isSigning = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
