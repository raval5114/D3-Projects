import 'package:flutter/material.dart';
import 'package:pdf_esigner/widgets/showPasswordPanel.dart';

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
              onPressed: () {
                // showDialog(
                //   context: context,
                //   builder: (context) => const PasswordPanel(),
                // );
              },
              child: Text("Click Here")),
        ));
  }
}
