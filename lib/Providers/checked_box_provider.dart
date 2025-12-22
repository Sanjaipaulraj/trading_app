// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CheckedBoxProvider extends ChangeNotifier {
//   bool isLongTcChecked = false;
//   bool isLongTtChecked = false;
//   bool isLongNeoChecked = false;
//   bool isLongHwoChecked = false;
//   bool isLongConfChecked = false;
//   bool isShortTcChecked = false;
//   bool isShortTtChecked = false;
//   bool isShortNeoChecked = false;
//   bool isShortHwoChecked = false;
//   bool isShortConfChecked = false;
//   bool isReversalPlusChecked = false;
//   bool isSignalExitChecked = false;
//   bool isTcChangeChecked = false;
//   bool _isLoading = true;

//   bool get isLoading => _isLoading;

//   bool get isLongAllChecked =>
//       isLongTcChecked && isLongTtChecked && isLongNeoChecked && isLongHwoChecked && isLongConfChecked;

//   bool get isShortAllChecked =>
//       isShortTcChecked && isShortTtChecked && isShortNeoChecked && isShortHwoChecked && isShortConfChecked;

//   CheckedBoxProvider() {
//     _loadValues();
//   }

//   Future<void> _loadValues() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isLongTcChecked = prefs.getBool('LongTcChecked') ?? false;
//     isLongTtChecked = prefs.getBool('LongTtChecked') ?? false;
//     isLongNeoChecked = prefs.getBool('LongNeoChecked') ?? false;
//     isLongHwoChecked = prefs.getBool('LongHwoChecked') ?? false;
//     isLongConfChecked = prefs.getBool('LongConfChecked') ?? false;
//     isShortTcChecked = prefs.getBool('ShortTcChecked') ?? false;
//     isShortTtChecked = prefs.getBool('ShortTtChecked') ?? false;
//     isShortNeoChecked = prefs.getBool('ShortNeoChecked') ?? false;
//     isShortHwoChecked = prefs.getBool('ShortHwoChecked') ?? false;
//     isShortConfChecked = prefs.getBool('ShortConfChecked') ?? false;
//     isReversalPlusChecked = prefs.getBool('ReversalPlusChecked') ?? false;
//     isSignalExitChecked = prefs.getBool('SignalExitChecked') ?? false;
//     isTcChangeChecked = prefs.getBool('TcChangeChecked') ?? false;
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> setBoolValue(String key, bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(key, value);
//   }

//   void changeValue(String field) {
//     switch (field) {
//       case 'LongTcChecked':
//         isLongTcChecked = !isLongTcChecked;
//         isShortTcChecked = false;
//         setBoolValue('LongTcChecked', isLongTcChecked);
//         setBoolValue('ShortTcChecked', isShortTcChecked);
//         break;
//       case 'LongTtChecked':
//         isLongTtChecked = !isLongTtChecked;
//         isShortTtChecked = false;
//         setBoolValue('LongTtChecked', isLongTtChecked);
//         setBoolValue('ShortTtChecked', isShortTtChecked);
//         break;
//       case 'LongNeoChecked':
//         isLongNeoChecked = !isLongNeoChecked;
//         isShortNeoChecked = false;
//         setBoolValue('LongNeoChecked', isLongNeoChecked);
//         setBoolValue('ShortNeoChecked', isShortNeoChecked);
//         break;
//       case 'LongHwoChecked':
//         isLongHwoChecked = !isLongHwoChecked;
//         isShortHwoChecked = false;
//         setBoolValue('LongHwoChecked', isLongHwoChecked);
//         setBoolValue('ShortHwoChecked', isShortHwoChecked);
//         break;
//       case 'LongConfChecked':
//         isLongConfChecked = !isLongConfChecked;
//         isShortConfChecked = false;
//         setBoolValue('LongConfChecked', isLongConfChecked);
//         setBoolValue('ShortConfChecked', isShortConfChecked);
//         break;
//       case 'ShortTcChecked':
//         isShortTcChecked = !isShortTcChecked;
//         isLongTcChecked = false;
//         setBoolValue('ShortTcChecked', isShortTcChecked);
//         setBoolValue('LongTcChecked', isLongTcChecked);
//         break;
//       case 'ShortTtChecked':
//         isShortTtChecked = !isShortTtChecked;
//         isLongTtChecked = false;
//         setBoolValue('ShortTtChecked', isShortTtChecked);
//         setBoolValue('LongTtChecked', isLongTtChecked);
//         break;
//       case 'ShortNeoChecked':
//         isShortNeoChecked = !isShortNeoChecked;
//         isLongNeoChecked = false;
//         setBoolValue('ShortNeoChecked', isShortNeoChecked);
//         setBoolValue('LongNeoChecked', isLongNeoChecked);
//         break;
//       case 'ShortHwoChecked':
//         isShortHwoChecked = !isShortHwoChecked;
//         isLongHwoChecked = false;
//         setBoolValue('ShortHwoChecked', isShortHwoChecked);
//         setBoolValue('LongHwoChecked', isLongHwoChecked);
//         break;
//       case 'ShortConfChecked':
//         isShortConfChecked = !isShortConfChecked;
//         isLongConfChecked = false;
//         setBoolValue('ShortConfChecked', isShortConfChecked);
//         setBoolValue('LongConfChecked', isLongConfChecked);
//         break;
//       case 'Reversal Plus':
//         isReversalPlusChecked = !isReversalPlusChecked;
//         setBoolValue('ReversalPlusChecked', isReversalPlusChecked);
//         break;
//       case 'Signal Exit':
//         isSignalExitChecked = !isSignalExitChecked;
//         setBoolValue('SignalExitChecked', isSignalExitChecked);
//         break;
//       case 'Tc Change':
//         isTcChangeChecked = !isTcChangeChecked;
//         setBoolValue('TcChangeChecked', isTcChangeChecked);
//         break;
//     }
//     notifyListeners();
//   }
// }

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
