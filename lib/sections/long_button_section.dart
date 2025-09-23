import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/checked_box_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/token_provider.dart';

class LongButtonSection extends StatefulWidget {
  const LongButtonSection({super.key});

  @override
  State<LongButtonSection> createState() => _LongButtonSectionState();
}

class _LongButtonSectionState extends State<LongButtonSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Mytoken, CheckedBox>(
      builder: (context, myToken, checkedBox, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black, width: 2),
                ),
                elevation: 8.0,
                foregroundColor: Colors.black,
                backgroundColor: checkedBox.isLongAllChecked ? Colors.lightGreen : Colors.grey,
                textStyle: TextStyle(inherit: true, fontSize: 18, fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: checkedBox.isLongAllChecked
                  ? () {
                      final token = Provider.of<Mytoken>(context, listen: false).token;
                      if (token != null) {
                        Actions.invoke(context, const LongIntent());
                        toastification.show(
                          backgroundColor: Color.fromRGBO(199, 226, 201, 1),
                          context: context,
                          title: const Text('Success!'),
                          description: const Text('Your value submitted successfully'),
                          type: ToastificationType.success,
                          alignment: Alignment.center,
                          autoCloseDuration: const Duration(seconds: 2),
                        );
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
              child: Text('Long'),
            ),
            SizedBox(height: 5),
            _buildCheckboxRow('LongTcChecked', checkedBox),
            _buildCheckboxRow('LongTtChecked', checkedBox),
            _buildCheckboxRow('LongNeoChecked', checkedBox),
            _buildCheckboxRow('LongHwoChecked', checkedBox),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxRow(String checkboxField, CheckedBox checkedBox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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

  bool _getCheckboxValue(String checkboxField, CheckedBox checkedBox) {
    switch (checkboxField) {
      case 'LongTcChecked':
        return checkedBox.isLongTcChecked;
      case 'LongTtChecked':
        return checkedBox.isLongTtChecked;
      case 'LongNeoChecked':
        return checkedBox.isLongNeoChecked;
      case 'LongHwoChecked':
        return checkedBox.isLongHwoChecked;
      default:
        return false;
    }
  }
}
