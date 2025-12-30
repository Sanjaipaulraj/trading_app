import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';

class AutomaticClosingSection extends StatefulWidget {
  const AutomaticClosingSection({super.key});

  @override
  State<AutomaticClosingSection> createState() => _AutomaticClosingSectionState();
}

class _AutomaticClosingSectionState extends State<AutomaticClosingSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckedBoxProvider>(
      builder: (context, checkedbox, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.start,
                'Automatic Closing',
                style: TextStyle(color: Color.fromRGBO(101, 101, 255, 1), fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildCheckboxRow('ReversalPlusChecked', 'Reversal Plus', checkedbox, context),
              _buildCheckboxRow('ReversalChecked', 'Reversal', checkedbox, context),
              _buildCheckboxRow('SignalExitChecked', 'Signal Exit', checkedbox, context),
              _buildCheckboxRow('TcChangeChecked', 'Tc Change', checkedbox, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckboxRow(String key, String label, CheckedBoxProvider checkedBox, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        SizedBox(
          width: 150,
          child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Checkbox(
            value: _getCheckboxValue(key, checkedBox),
            onChanged: (bool? newValue) {
              checkedBox.changeValue(key, context);
            },
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
        ),
      ],
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'ReversalPlusChecked':
        return checkedBox.isReversalPlusChecked;
      case 'ReversalChecked':
        return checkedBox.isReversalChecked;
      case 'SignalExitChecked':
        return checkedBox.isSignalExitChecked;
      case 'TcChangeChecked':
        return checkedBox.isTcChangeChecked;
      default:
        return false;
    }
  }
}
