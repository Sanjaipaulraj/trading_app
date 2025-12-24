import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValueProvider extends ChangeNotifier {
  String? selectedValue;
  SearchFieldListItem<String>? selectedItem;
  num volume = 1.03;
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

  void setSelectedValue(String value) {
    selectedValue = value;
    notifyListeners();
  }

  void clearSelectedValue() {
    selectedValue = null;
    selectedItem = null;
    notifyListeners();
  }

  void setSelectedItem(SearchFieldListItem<String> item) {
    selectedItem = item; // UI-safe object
    selectedValue = item.searchKey; // pure data
    notifyListeners();
  }
}
