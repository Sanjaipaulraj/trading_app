import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValueProvider extends ChangeNotifier {
  String _dropdown = "";
  double volume = 1.03;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  ValueProvider() {
    _loadVolume();
  }

  Future<void> _loadVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    volume = prefs.getDouble('volume') ?? 1.03;
    _isLoading = false;
    notifyListeners();
  }

  void setVolume(double value) async {
    volume = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value);
    notifyListeners();
  }

  String get dropdown => _dropdown;

  void setDropdown(String value) {
    _dropdown = value;
    notifyListeners();
  }
}
