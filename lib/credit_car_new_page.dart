import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';

import 'package:nfc_new_app/scan_option_configure_widget.dart';

class CreditCardScannerNewPage extends StatefulWidget {
  const CreditCardScannerNewPage({Key? key}) : super(key: key);




  @override
  State<CreditCardScannerNewPage> createState() => _CreditCardScannerNewPageState();
}

class _CreditCardScannerNewPageState extends State<CreditCardScannerNewPage> {
  CardDetails? _cardDetails;
  Uint8List? _glossyCardImage;
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    scanExpiryDate: true,
    enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeCamera();
    });
  }

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(_cameras.first, ResolutionPreset.high);
        await _cameraController!.initialize();
        setState(() {});
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> scanCard() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera is not initialized');
      return;
    }

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Apply glossy effect to the captured image
      Uint8List glossyImage = applyGlossyEffect(imageBytes);

      final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
      if (!mounted || cardDetails == null) return;

      setState(() {
        _cardDetails = cardDetails;
        _glossyCardImage = glossyImage;
      });
    } catch (e) {
      print('Error scanning card: $e');
    }
  }

  Uint8List applyGlossyEffect(Uint8List imageBytes) {
    img.Image image = img.decodeImage(imageBytes)!;
    img.Image glossyImage = img.copyResize(image, width: image.width, height: image.height);

    // Apply glossy effect - this is a simple example, adjust as needed
    for (int y = 0; y < glossyImage.height; y++) {
      for (int x = 0; x < glossyImage.width; x++) {
        int pixel = glossyImage.getPixel(x, y);
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);

        // Simple glossy effect: increase brightness
        int newR = (r + 50).clamp(0, 255);
        int newG = (g + 50).clamp(0, 255);
        int newB = (b + 50).clamp(0, 255);

        glossyImage.setPixel(x, y, img.getColor(newR, newG, newB));
      }
    }

    return Uint8List.fromList(img.encodePng(glossyImage));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Credit Card Scanner App'),
        ),
        body: _cameraController == null || !_cameraController!.value.isInitialized
            ? Center(child: CircularProgressIndicator())
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  scanCard();
                },
                child: const Text('Scan Card'),
              ),
              _cardDetails != null
                  ? Column(
                children: [
                  Text('Card Number: ${_cardDetails!.cardNumber}'),
                  if (_glossyCardImage != null)
                    Image.memory(_glossyCardImage!),
                ],
              )
                  : Container(),
              Expanded(
                child: OptionConfigureWidget(
                  initialOptions: scanOptions,
                  onScanOptionChanged: (newOptions) => scanOptions = newOptions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
