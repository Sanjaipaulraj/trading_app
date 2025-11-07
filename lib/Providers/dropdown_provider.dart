import 'package:flutter/material.dart';

class DropdownProvider extends ChangeNotifier {
  String _dropdown = "";

  String get dropdown => _dropdown;

  void setDropdown(String value) {
    _dropdown = value;
    notifyListeners();
  }
}
