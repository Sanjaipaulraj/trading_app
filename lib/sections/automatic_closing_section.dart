import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';

class AutomaticClosingSection extends StatefulWidget {
  final String method;
  const AutomaticClosingSection({super.key, required this.method});

  @override
  State<AutomaticClosingSection> createState() => _AutomaticClosingSectionState();
}

class _AutomaticClosingSectionState extends State<AutomaticClosingSection> {
  String get reversalPlus => {
    'method1': 'M1ReversalPlusChecked',
    'method2': 'M2ReversalPlusChecked',
    'method3': 'M3ReversalPlusChecked',
  }[widget.method]!;

  String get reversal =>
      {'method1': 'M1ReversalChecked', 'method2': 'M2ReversalChecked', 'method3': 'M3ReversalChecked'}[widget.method]!;

  String get signal => {
    'method1': 'M1SignalExitChecked',
    'method2': 'M2SignalExitChecked',
    'method3': 'M3SignalExitChecked',
  }[widget.method]!;

  String get tc =>
      {'method1': 'M1TcChangeChecked', 'method2': 'M2TcChangeChecked', 'method3': 'M3TcChangeChecked'}[widget.method]!;

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
                      style: TextStyle(
                        color: const Color.fromRGBO(4, 46, 124, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(0, 0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(24, 55, 69, 1),
                          )
                        : ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(0, 0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      checkedbox.changeValue(widget.method, reversalPlus, context);
                    },
                    child: Row(
                      spacing: 3,
                      mainAxisSize: MainAxisSize.min,
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
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(24, 55, 69, 1),
                          )
                        : ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      checkedbox.changeValue(widget.method, reversal, context);
                    },
                    child: Text("Rev", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  ElevatedButton(
                    style: _getCheckboxValue(signal, checkedbox)
                        ? ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(24, 55, 69, 1),
                          )
                        : ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      checkedbox.changeValue(widget.method, signal, context);
                    },
                    child: Row(
                      spacing: 3,
                      mainAxisSize: MainAxisSize.min,
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
                  ElevatedButton(
                    style: _getCheckboxValue(tc, checkedbox)
                        ? ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(24, 55, 69, 1),
                          )
                        : ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            // minimumSize: Size(50, 30),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromRGBO(190, 190, 190, 1),
                          ),
                    onPressed: () {
                      checkedbox.changeValue(widget.method, tc, context);
                    },
                    child: Row(
                      spacing: 3,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Tc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      case 'M1ReversalPlusChecked':
        return checkedBox.isM1ReversalPlusChecked;
      case 'M1ReversalChecked':
        return checkedBox.isM1ReversalChecked;
      case 'M1SignalExitChecked':
        return checkedBox.isM1SignalExitChecked;
      case 'M1TcChangeChecked':
        return checkedBox.isM1TcChangeChecked;
      case 'M2ReversalPlusChecked':
        return checkedBox.isM2ReversalPlusChecked;
      case 'M2ReversalChecked':
        return checkedBox.isM2ReversalChecked;
      case 'M2SignalExitChecked':
        return checkedBox.isM2SignalExitChecked;
      case 'M2TcChangeChecked':
        return checkedBox.isM2TcChangeChecked;
      case 'M3ReversalPlusChecked':
        return checkedBox.isM3ReversalPlusChecked;
      case 'M3ReversalChecked':
        return checkedBox.isM3ReversalChecked;
      case 'M3SignalExitChecked':
        return checkedBox.isM3SignalExitChecked;
      case 'M3TcChangeChecked':
        return checkedBox.isM3TcChangeChecked;
      default:
        return false;
    }
  }
}
