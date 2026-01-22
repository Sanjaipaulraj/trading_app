import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';

class Method3Section extends StatefulWidget {
  const Method3Section({super.key});

  @override
  State<Method3Section> createState() => _Method3SectionState();
}

class _Method3SectionState extends State<Method3Section> {
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
                "Method 3",
                style: TextStyle(color: Color.fromRGBO(4, 46, 124, 1), fontSize: 16, fontWeight: FontWeight.w600),
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
                          backgroundColor: checkedBox.isM3LongAllChecked ? Colors.lightGreen : Colors.grey,
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM3LongAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const LongIntent(method: 'method3', actionType: "ORDER_TYPE_BUY"),
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
                          backgroundColor: checkedBox.isM3ShortAllChecked ? Colors.red : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          elevation: 8.0,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM3ShortAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const ShortIntent(method: 'method3', actionType: "ORDER_TYPE_SELL"),
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
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'TC',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      'Sig.Cr.TT',
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
                      _buildCheckboxColumn('long', 'LongGretTcChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongSigCrTtChecked', checkedBox),
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
                      _buildCheckboxColumn('short', 'ShortGretTcChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortSigCrTtChecked', checkedBox),
                    ],
                  );
                },
              ),
            ],
          ),
          AutomaticClosingSection(method: 'method3'),
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
              checkedBox.changeValue('method3', checkboxField, context);
            });
          },
          activeColor: method == 'long' ? Colors.green : Colors.red,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.comfortable,
        ),
      ],
    );
  }

  Widget _buildCheckboxColumn(String method, String checkboxField, CheckedBoxProvider checkedBox) {
    return Column(
      children: [
        Checkbox(
          value: _getCheckboxValue(checkboxField, checkedBox),
          onChanged: (bool? newValue) {
            setState(() {
              checkedBox.changeValue('method3', checkboxField, context);
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.comfortable,
        ),
        if (method == 'long')
          Text("> TT", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
        else
          Text("< TT", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'LongGretTcChecked':
        return checkedBox.isLongGretTcChecked;
      case 'LongSigCrTtChecked':
        return checkedBox.isLongSigCrTtChecked;
      case 'ShortGretTcChecked':
        return checkedBox.isShortGretTcChecked;
      case 'ShortSigCrTtChecked':
        return checkedBox.isShortSigCrTtChecked;
      default:
        return false;
    }
  }
}
