import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';

class Method1Section extends StatefulWidget {
  const Method1Section({super.key});

  @override
  State<Method1Section> createState() => _Method1SectionState();
}

class _Method1SectionState extends State<Method1Section> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Method 1",
                style: TextStyle(color: const Color.fromRGBO(4, 46, 124, 1), fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Consumer2<MytokenProvider, CheckedBoxProvider>(
                builder: (context, myToken, checkedBox, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 35),
                          maximumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          elevation: 8.0,
                          foregroundColor: Colors.black,
                          backgroundColor: checkedBox.isM1LongAllChecked ? Colors.lightGreen : Colors.grey,
                          textStyle: TextStyle(inherit: true, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM1LongAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const LongIntent(method: 'method1', actionType: "ORDER_TYPE_BUY"),
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 35),
                          maximumSize: Size(100, 50),
                          backgroundColor: checkedBox.isM1ShortAllChecked ? Colors.red : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          elevation: 8.0,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM1ShortAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const ShortIntent(method: 'method1', actionType: "ORDER_TYPE_SELL"),
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
                        child: Text('Short'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Catcher',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Tracer',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'NEO Cloud',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Confirmation',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'OSC',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Consumer2<MytokenProvider, CheckedBoxProvider>(
                builder: (context, myToken, checkedBox, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildCheckboxRow('long', 'LongTcChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongTtChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongNeoChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongConfChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongHwoChecked', checkedBox),
                    ],
                  );
                },
              ),
              Consumer2<MytokenProvider, CheckedBoxProvider>(
                builder: (context, myToken, checkedBox, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildCheckboxRow('short', 'ShortTcChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortTtChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortNeoChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortConfChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortHwoChecked', checkedBox),
                    ],
                  );
                },
              ),
            ],
          ),
          AutomaticClosingSection(method: 'method1'),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(String method, String checkboxField, CheckedBoxProvider checkedBox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (method == 'long')
          Icon(Icons.arrow_upward_rounded, color: Colors.green, size: 22.0)
        else
          Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 22.0),
        Checkbox(
          value: _getCheckboxValue(checkboxField, checkedBox),
          onChanged: (bool? newValue) {
            setState(() {
              checkedBox.changeValue('method1', checkboxField, context);
            });
          },
          activeColor: method == 'long' ? Colors.green : Colors.red,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'LongTcChecked':
        return checkedBox.isLongTcChecked;
      case 'LongTtChecked':
        return checkedBox.isLongTtChecked;
      case 'LongNeoChecked':
        return checkedBox.isLongNeoChecked;
      case 'LongHwoChecked':
        return checkedBox.isLongHwoChecked;
      case 'LongConfChecked':
        return checkedBox.isLongConfChecked;
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
