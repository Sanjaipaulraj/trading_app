import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auditplus_fx/Providers/checked_box_provider.dart';

class AutomaticClosingSection extends StatefulWidget {
  final String method;
  const AutomaticClosingSection({super.key, required this.method});

  @override
  State<AutomaticClosingSection> createState() => _AutomaticClosingSectionState();
}

class _AutomaticClosingSectionState extends State<AutomaticClosingSection> {
  String get reversalPlus => {'MM1': 'MM1ReversalPlusChecked', 'MM2': 'MM2ReversalPlusChecked'}[widget.method]!;

  String get reversal => {'MM1': 'MM1ReversalChecked', 'MM2': 'MM2ReversalChecked'}[widget.method]!;

  String get signal => {'MM1': 'MM1SignalExitChecked', 'MM2': 'MM2SignalExitChecked'}[widget.method]!;

  String get tc => {'MM1': 'MM1TcChangeChecked', 'MM2': 'MM2TcChangeChecked'}[widget.method]!;

  String get hw => {'MM1': 'MM1HwChecked', 'MM2': 'MM2HwChecked'}[widget.method]!;

  String get mf => {'MM1': 'MM1MfChecked', 'MM2': 'MM2MfChecked'}[widget.method]!;

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckedBoxProvider>(
      builder: (context, checkedbox, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Automatic Closing",
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: _getCheckboxValue(reversalPlus, checkedbox)
                        ? ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, reversalPlus, context);
                      // checkedbox.changeValue(null, widget.method, reversalPlus, context);
                      checkedbox.changeValue(null, "MM", reversalPlus, context);
                    },
                    child: Row(
                      spacing: 3,
                      children: [
                        Text("Rev", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Icon(
                          Icons.add,
                          color: _getCheckboxValue(reversalPlus, checkedbox)
                              ? Color.fromRGBO(6, 255, 14, 1)
                              : Color.fromRGBO(0, 57, 2, 1),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: _getCheckboxValue(reversal, checkedbox)
                        ? ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, reversal, context);
                      // checkedbox.changeValue(null, widget.method, reversal, context);
                      checkedbox.changeValue(null, "MM", reversal, context);
                    },
                    child: Text("Rev", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  ElevatedButton(
                    style: _getCheckboxValue(signal, checkedbox)
                        ? ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, signal, context);
                      // checkedbox.changeValue(null, widget.method, signal, context);
                      checkedbox.changeValue(null, "MM", signal, context);
                    },
                    child: Row(
                      spacing: 3,
                      children: [
                        Text("Sig", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Icon(
                          Icons.close,
                          color: _getCheckboxValue(signal, checkedbox) ? Colors.red : Color.fromRGBO(102, 7, 0, 1),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: _getCheckboxValue(tc, checkedbox)
                        ? ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, tc, context);
                      // checkedbox.changeValue(null, widget.method, tc, context);
                      checkedbox.changeValue(null, "MM", tc, context);
                    },
                    child: Row(
                      spacing: 3,
                      children: [
                        Text("TC", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: _getCheckboxValue(tc, checkedbox)
                              ? Color.fromRGBO(6, 255, 14, 1)
                              : Color.fromRGBO(0, 57, 2, 1),
                          size: 20.0,
                        ),
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: _getCheckboxValue(tc, checkedbox) ? Colors.red : Color.fromRGBO(102, 7, 0, 1),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: _getCheckboxValue(hw, checkedbox)
                        ? ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, hw, context);
                      // checkedbox.changeValue(null, widget.method, hw, context);
                      checkedbox.changeValue(null, "MM", hw, context);
                    },
                    child: Row(
                      spacing: 3,
                      children: [
                        Text("HW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: _getCheckboxValue(hw, checkedbox)
                              ? Color.fromRGBO(6, 255, 14, 1)
                              : Color.fromRGBO(0, 57, 2, 1),
                          size: 20.0,
                        ),
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: _getCheckboxValue(hw, checkedbox) ? Colors.red : Color.fromRGBO(102, 7, 0, 1),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: _getCheckboxValue(mf, checkedbox)
                        ? ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(33, 52, 72, 1),
                          )
                        : ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      // checkedbox.changeValue(widget.method, mf, context);
                      // checkedbox.changeValue(null, widget.method, mf, context);
                      checkedbox.changeValue(null, "MM", mf, context);
                    },
                    child: Row(
                      spacing: 3,
                      children: [
                        Text("MF", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: _getCheckboxValue(hw, checkedbox)
                              ? Color.fromRGBO(6, 255, 14, 1)
                              : Color.fromRGBO(0, 57, 2, 1),
                          size: 20.0,
                        ),
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: _getCheckboxValue(mf, checkedbox) ? Colors.red : Color.fromRGBO(102, 7, 0, 1),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _getCheckboxValue(String checkboxField, CheckedBoxProvider checkedBox) {
    switch (checkboxField) {
      case 'MM1ReversalPlusChecked':
        return checkedBox.isMM1ReversalPlusChecked;
      case 'MM1ReversalChecked':
        return checkedBox.isMM1ReversalChecked;
      case 'MM1SignalExitChecked':
        return checkedBox.isMM1SignalExitChecked;
      case 'MM1TcChangeChecked':
        return checkedBox.isMM1TcChangeChecked;
      case 'MM1HwChecked':
        return checkedBox.isMM1HwChecked;
      case 'MM1MfChecked':
        return checkedBox.isMM1MfChecked;
      case 'MM2ReversalPlusChecked':
        return checkedBox.isMM2ReversalPlusChecked;
      case 'MM2ReversalChecked':
        return checkedBox.isMM2ReversalChecked;
      case 'MM2SignalExitChecked':
        return checkedBox.isMM2SignalExitChecked;
      case 'MM2TcChangeChecked':
        return checkedBox.isMM2TcChangeChecked;
      case 'MM2HwChecked':
        return checkedBox.isMM2HwChecked;
      case 'MM2MfChecked':
        return checkedBox.isMM2MfChecked;
      // case 'M3ReversalPlusChecked':
      //   return checkedBox.isM3ReversalPlusChecked;
      // case 'M3ReversalChecked':
      //   return checkedBox.isM3ReversalChecked;
      // case 'M3SignalExitChecked':
      //   return checkedBox.isM3SignalExitChecked;
      // case 'M3TcChangeChecked':
      //   return checkedBox.isM3TcChangeChecked;
      // case 'M3HwChecked':
      //   return checkedBox.isM3HwChecked;
      default:
        return false;
    }
  }
}
