import 'package:flutter/material.dart';
import 'dart:async';

import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:nfc_new_app/scan_option_configure_widget.dart';




class CreditCardScannerPage extends StatefulWidget {
  const CreditCardScannerPage({Key? key}) : super(key: key);

  @override
  State<CreditCardScannerPage> createState() => _CreditCardScannerPageState();
}

class _CreditCardScannerPageState extends State<CreditCardScannerPage> {
  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  Future<void> scanCard() async {
    final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    if ( !mounted || cardDetails == null ) return;
    setState(() {
      _cardDetails = cardDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('credit_card_scanner app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  scanCard();
                },
                child: const Text('scan card'),
              ),
              Text('$_cardDetails'),
              Expanded(
                child: OptionConfigureWidget(
                  initialOptions: scanOptions,
                  onScanOptionChanged: (newOptions) => scanOptions = newOptions,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}