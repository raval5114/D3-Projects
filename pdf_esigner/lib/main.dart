import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'package:pdf_esigner/pages/homepage.dart';
import 'package:pdf_esigner/pages/homepage_web.dart';
import 'package:pdf_esigner/test/multiple_file_Picking_feature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainTestingHomepage(),
    );
  }
}

class CrossHomePage extends StatelessWidget {
  const CrossHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebHomepage();
    }
    if (!kIsWeb && Platform.isAndroid) {
      return Homepage();
    } else {
      return const Placeholder();
    }
  }
}
