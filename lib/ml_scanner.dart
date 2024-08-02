import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class MlScannerPage extends StatefulWidget {
  const MlScannerPage({super.key});

  @override
  State<MlScannerPage> createState() => _MlScannerPageState();
}

class _MlScannerPageState extends State<MlScannerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Scanner Example'),
      ),

    );
  }

}