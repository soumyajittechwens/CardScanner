// scan_option_configure_widget.dart

import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

class OptionConfigureWidget extends StatefulWidget {
  final CardScanOptions initialOptions;
  final ValueChanged<CardScanOptions> onScanOptionChanged;

  OptionConfigureWidget({
    required this.initialOptions,
    required this.onScanOptionChanged,
  });

  @override
  _OptionConfigureWidgetState createState() => _OptionConfigureWidgetState();
}

class _OptionConfigureWidgetState extends State<OptionConfigureWidget> {
  late bool scanCardHolderName;
  late int validCardsToScanBeforeFinishingScan;

  @override
  void initState() {
    super.initState();
    scanCardHolderName = widget.initialOptions.scanCardHolderName;
    validCardsToScanBeforeFinishingScan = widget.initialOptions.validCardsToScanBeforeFinishingScan;
  }

  void _updateOptions() {
    widget.onScanOptionChanged(
      CardScanOptions(
        scanCardHolderName: scanCardHolderName,
        validCardsToScanBeforeFinishingScan: validCardsToScanBeforeFinishingScan,
        possibleCardHolderNamePositions: widget.initialOptions.possibleCardHolderNamePositions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Scan Card Holder Name'),
          value: scanCardHolderName,
          onChanged: (bool value) {
            setState(() {
              scanCardHolderName = value;
            });
            _updateOptions();
          },
        ),
        ListTile(
          title: const Text('Valid Cards to Scan Before Finishing Scan'),
          trailing: DropdownButton<int>(
            value: validCardsToScanBeforeFinishingScan,
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  validCardsToScanBeforeFinishingScan = newValue;
                });
                _updateOptions();
              }
            },
            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
