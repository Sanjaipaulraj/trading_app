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
              _buildCheckboxRow('Reversal Plus', checkedbox),
              _buildCheckboxRow('Signal Exit', checkedbox),
              _buildCheckboxRow('Tc Change', checkedbox),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckboxRow(String checkboxField, CheckedBoxProvider checkedBox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        SizedBox(
          width: 150,
          child: Text(checkboxField, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Checkbox(
            value: _getCheckboxValue(checkboxField, checkedBox),
            onChanged: (bool? newValue) {
              setState(() {
                checkedBox.changeValue(checkboxField);
              });
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
      case 'Reversal Plus':
        return checkedBox.isReversalPlusChecked;
      case 'Signal Exit':
        return checkedBox.isSignalExitChecked;
      case 'Tc Change':
        return checkedBox.isTcChangeChecked;
      default:
        return false;
    }
  }
}
