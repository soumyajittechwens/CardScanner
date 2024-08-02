import 'package:flutter/material.dart';
import 'package:nfc_new_app/credit_scanner.dart';
import 'package:nfc_new_app/ml_scanner.dart';

import 'card_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visa Card Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const CardScannerPage(),
    );
  }
}


