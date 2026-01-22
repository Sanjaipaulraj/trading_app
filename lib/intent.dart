import 'package:flutter/material.dart';

class LongIntent extends Intent {
  final String actionType;
  final String method;
  const LongIntent({required this.actionType, required this.method});
}

class ShortIntent extends Intent {
  final String actionType;
  final String method;
  const ShortIntent({required this.actionType, required this.method});
}

class CloseIntent extends Intent {
  final String actionType;
  const CloseIntent({required this.actionType});
}
