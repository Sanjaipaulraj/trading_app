import 'package:flutter/material.dart';

class LongIntent extends Intent {
  final String actionType;
  const LongIntent({required this.actionType});
}

class ShortIntent extends Intent {
  final String actionType;
  const ShortIntent({required this.actionType});
}

class CloseIntent extends Intent {
  final String actionType;
  const CloseIntent({required this.actionType});
}
