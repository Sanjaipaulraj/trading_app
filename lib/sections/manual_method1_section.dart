import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:auditplus_fx/Providers/checked_box_provider.dart';
import 'package:auditplus_fx/Providers/token_provider.dart';
import 'package:auditplus_fx/intent.dart';
import 'package:auditplus_fx/sections/automatic_closing_section.dart';

class ManualMethod1Section extends StatefulWidget {
  const ManualMethod1Section({super.key});

  @override
  State<ManualMethod1Section> createState() => _ManualMethod1SectionState();
}

class _ManualMethod1SectionState extends State<ManualMethod1Section> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: double.infinity),
      color: Color.fromRGBO(189, 232, 245, 1),
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Method 1",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Consumer2<MytokenProvider, CheckedBoxProvider>(
                builder: (context, myToken, checkedBox, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                          maximumSize: Size(100, 50),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                    const LongIntent(method: 'MM1', actionType: "ORDER_TYPE_BUY"),
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
                          minimumSize: Size(100, 40),
                          maximumSize: Size(100, 50),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                    const ShortIntent(method: 'MM1', actionType: "ORDER_TYPE_SELL"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Text(
                      'Catcher',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Text(
                      'Tracer',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Text(
                      'NEO Cloud',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Text(
                      'Confirmation',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
          AutomaticClosingSection(method: 'MM1'),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(String method, String checkboxField, CheckedBoxProvider checkedBox) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (method == 'long')
          Icon(Icons.arrow_upward_rounded, color: Colors.green, size: 18)
        else
          Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 18),
        Checkbox(
          value: _getCheckboxValue(checkboxField, checkedBox),
          onChanged: (bool? newValue) {
            setState(() {
              // checkedBox.changeValue('MM1', checkboxField, context);
              checkedBox.changeValue(null, 'MM1', checkboxField, context);
            });
          },
          activeColor: method == 'long' ? Colors.green : Colors.red,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
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
