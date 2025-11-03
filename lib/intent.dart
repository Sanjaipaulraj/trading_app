import 'package:flutter/material.dart';

class LongIntent extends Intent {
  const LongIntent();
}

class ShortIntent extends Intent {
  const ShortIntent();
}

class CloseIntent extends Intent {
  final String actionType;
  final String symbol;
  const CloseIntent({required this.actionType, required this.symbol});
}
