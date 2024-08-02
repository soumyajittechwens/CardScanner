import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_scanner/models/card_details.dart';
import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/material.dart';




class CardScannerPage extends StatefulWidget {

  const CardScannerPage({super.key});

  @override
  State<CardScannerPage> createState() => _CardScannerPageState();
}

class _CardScannerPageState extends State<CardScannerPage> {
  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.belowCardNumber,
    ],
  );
  Future<void> scanCard() async {
    final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    print("_cardDetails==$_cardDetails");
    if ( !mounted || cardDetails == null ) return;
    setState(() {
      _cardDetails = cardDetails;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Card Scanner',style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Card Number : ',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey)),
                        _cardDetails?.cardNumber!=null?Text('${_cardDetails?.cardNumber}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)):const Text(""),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Card Exp Date : ',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey)),
                        _cardDetails?.expiryDate!=null? Text('${_cardDetails?.expiryDate}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)):const Text(""),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Card Holder Name : ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey)),
                        _cardDetails?.cardHolderName!=null?Text('${_cardDetails?.cardHolderName}',style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)):const Text(""),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    scanCard();
                  },
                  child: const Text('scan card',style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }

}