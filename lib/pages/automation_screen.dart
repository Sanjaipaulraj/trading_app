import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../sections/sections.dart';

class AutomationScreen extends StatefulWidget {
  final List<SearchFieldListItem<String>> symbols;
  const AutomationScreen({super.key, required this.symbols});

  @override
  State<AutomationScreen> createState() => _AutomationScreenState();
}

class _AutomationScreenState extends State<AutomationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(209, 238, 250, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [Method3Section(symbols: widget.symbols)],
        ),
      ),
    );
  }
}
