import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/intent.dart';
import 'package:trading_app/sections/automatic_closing_section.dart';

class Method2Section extends StatefulWidget {
  const Method2Section({super.key});

  @override
  State<Method2Section> createState() => _Method2SectionState();
}

class _Method2SectionState extends State<Method2Section> {
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
                "Method 2",
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
                          minimumSize: Size(100, 25),
                          maximumSize: Size(100, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          elevation: 8.0,
                          foregroundColor: Colors.black,
                          backgroundColor: checkedBox.isM2LongAllChecked ? Colors.lightGreen : Colors.grey,
                          textStyle: TextStyle(inherit: true, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM2LongAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const LongIntent(method: 'method2', actionType: "ORDER_TYPE_BUY"),
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
                          minimumSize: Size(100, 25),
                          maximumSize: Size(100, 45),
                          backgroundColor: checkedBox.isM2ShortAllChecked ? Colors.red : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          elevation: 8.0,
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: checkedBox.isM2ShortAllChecked
                            ? () {
                                final token = Provider.of<MytokenProvider>(context, listen: false).token;
                                if (token != null) {
                                  Actions.invoke(
                                    context,
                                    const ShortIntent(method: 'method2', actionType: "ORDER_TYPE_SELL"),
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
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
                    child: Text(
                      'Divergence',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      '(OR)',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: Text(
                      'Reversal Plus',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Catcher',
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
                      _buildCheckboxRow('long', 'LongDivergenceChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongRevChecked', checkedBox),
                      _buildCheckboxRow('long', 'LongCatcherChecked', checkedBox),
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
                      _buildCheckboxRow('short', 'ShortDivergenceChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortRevChecked', checkedBox),
                      _buildCheckboxRow('short', 'ShortCatcherChecked', checkedBox),
                    ],
                  );
                },
              ),
            ],
          ),
          AutomaticClosingSection(method: 'method2'),
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
              checkedBox.changeValue('method2', checkboxField, context);
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.comfortable,
        ),
      ],
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'LongDivergenceChecked':
        return checkedBox.isLongDivergenceChecked;
      case 'LongRevChecked':
        return checkedBox.isLongRevChecked;
      case 'LongCatcherChecked':
        return checkedBox.isLongCatcherChecked;
      case 'ShortDivergenceChecked':
        return checkedBox.isShortDivergenceChecked;
      case 'ShortRevChecked':
        return checkedBox.isShortRevChecked;
      case 'ShortCatcherChecked':
        return checkedBox.isShortCatcherChecked;
      default:
        return false;
    }
  }
}
