import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckedBoxProvider extends ChangeNotifier {
  String? _currentSymbol;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Map<String, bool> _values = _emptyValues();

  static Map<String, bool> _emptyValues() => {
    'LongTcChecked': false,
    'LongTtChecked': false,
    'LongNeoChecked': false,
    'LongHwoChecked': false,
    'LongConfChecked': false,
    'ShortTcChecked': false,
    'ShortTtChecked': false,
    'ShortNeoChecked': false,
    'ShortHwoChecked': false,
    'ShortConfChecked': false,
    'ReversalPlusChecked': false,
    'SignalExitChecked': false,
    'TcChangeChecked': false,
  };

  // --------- GETTERS (USED BY UI) ----------
  bool get isLongTcChecked => _values['LongTcChecked']!;
  bool get isLongTtChecked => _values['LongTtChecked']!;
  bool get isLongNeoChecked => _values['LongNeoChecked']!;
  bool get isLongHwoChecked => _values['LongHwoChecked']!;
  bool get isLongConfChecked => _values['LongConfChecked']!;

  bool get isShortTcChecked => _values['ShortTcChecked']!;
  bool get isShortTtChecked => _values['ShortTtChecked']!;
  bool get isShortNeoChecked => _values['ShortNeoChecked']!;
  bool get isShortHwoChecked => _values['ShortHwoChecked']!;
  bool get isShortConfChecked => _values['ShortConfChecked']!;

  bool get isReversalPlusChecked => _values['ReversalPlusChecked']!;
  bool get isSignalExitChecked => _values['SignalExitChecked']!;
  bool get isTcChangeChecked => _values['TcChangeChecked']!;

  bool get isLongAllChecked =>
      isLongTcChecked && isLongTtChecked && isLongNeoChecked && isLongHwoChecked && isLongConfChecked;

  bool get isShortAllChecked =>
      isShortTcChecked && isShortTtChecked && isShortNeoChecked && isShortHwoChecked && isShortConfChecked;

  // --------- LOAD BY SYMBOL ----------
  Future<void> loadForSymbol(String symbol) async {
    _isLoading = true;
    notifyListeners();

    _currentSymbol = symbol;
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('checkbox_state:$symbol');
    if (data == null) {
      _values = _emptyValues();
    } else {
      final decoded = Map<String, dynamic>.from(jsonDecode(data));
      _values = decoded.map((k, v) => MapEntry(k, v as bool));
    }

    _isLoading = false;
    notifyListeners();
  }

  // --------- SAVE ----------
  Future<void> _persist() async {
    if (_currentSymbol == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkbox_state:$_currentSymbol', jsonEncode(_values));
  }

  // --------- CHANGE VALUE ----------
  void changeValue(String field) {
    _values[field] = !(_values[field] ?? false);

    // enforce Long ↔ Short exclusivity
    if (field.startsWith('Long')) {
      _values[field.replaceFirst('Long', 'Short')] = false;
    }
    if (field.startsWith('Short')) {
      _values[field.replaceFirst('Short', 'Long')] = false;
    }

    _persist();
    notifyListeners();
  }

  // --------- CLEAR UI (ON CLOSE) ----------
  void clearState() {
    _values = _emptyValues();
    _currentSymbol = null;
    notifyListeners();
  }
}
