import 'package:flutter/material.dart';
import 'dart:js' as js;

class PasswordPanelTesting extends StatefulWidget {
  const PasswordPanelTesting({super.key});

  @override
  State<PasswordPanelTesting> createState() => _PasswordPanelTestingState();
}

class _PasswordPanelTestingState extends State<PasswordPanelTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Show Password Panel"),
          centerTitle: true,
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () => showBrowserPasswordDialog(),
              child: Text("Enter")),
        ));
  }
}

void showBrowserPasswordDialog() {
  // Use JavaScript's prompt function via dart:js
  var password = js.context.callMethod('prompt', ['Enter Password:', '']);

  // Check if password is entered or the prompt was canceled
  if (password != null && password.isNotEmpty) {
    print("Entered Password: $password");
  } else {
    print("Password entry was cancelled.");
  }
}
