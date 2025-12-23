import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/Providers/token_provider.dart';

class ShortButtonSection extends StatefulWidget {
  const ShortButtonSection({super.key});

  @override
  State<ShortButtonSection> createState() => _ShortButtonSectionState();
}

class _ShortButtonSectionState extends State<ShortButtonSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MytokenProvider, CheckedBoxProvider>(
      builder: (context, myToken, checkedBox, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 55),
                backgroundColor: checkedBox.isShortAllChecked ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                elevation: 8.0,
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: checkedBox.isShortAllChecked
                  ? () {
                      final token = Provider.of<MytokenProvider>(context, listen: false).token;
                      if (token != null) {
                        Actions.invoke(context, const ShortIntent(actionType: "ORDER_TYPE_SELL"));
                      } else {
                        toastification.show(
                          backgroundColor: Color.fromRGBO(242, 186, 185, 1),
                          context: context,
                          title: const Text('Error!'),
                          description: const Text('Your token is empty'),
                          type: ToastificationType.error,
                          alignment: Alignment.center,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
                      }
                    }
                  : null,
              child: Text('Short'),
            ),
            SizedBox(height: 5),
            _buildCheckboxRow('ShortTcChecked', checkedBox),
            _buildCheckboxRow('ShortTtChecked', checkedBox),
            _buildCheckboxRow('ShortNeoChecked', checkedBox),
            _buildCheckboxRow('ShortConfChecked', checkedBox),
            _buildCheckboxRow('ShortHwoChecked', checkedBox),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxRow(String checkboxField, CheckedBoxProvider checkedBox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 22.0),
        Checkbox(
          value: _getCheckboxValue(checkboxField, checkedBox),
          onChanged: (bool? newValue) {
            setState(() {
              checkedBox.changeValue(checkboxField);
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
      ],
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'ShortTcChecked':
        return checkedBox.isShortTcChecked;
      case 'ShortTtChecked':
        return checkedBox.isShortTtChecked;
      case 'ShortNeoChecked':
        return checkedBox.isShortNeoChecked;
      case 'ShortHwoChecked':
        return checkedBox.isShortHwoChecked;
      case 'ShortConfChecked':
        return checkedBox.isShortConfChecked;
      default:
        return false;
    }
  }
}
