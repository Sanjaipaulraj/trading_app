import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_app/Providers/value_provider.dart';

import '../api_methods/api_methods.dart';

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
    'LongDivergenceChecked': false,
    'LongRevChecked': false,
    'LongCatcherChecked': false,
    'LongOscChecked': false,
    'LongGretTcChecked': false,
    'LongSigCrTtChecked': false,
    'ShortTcChecked': false,
    'ShortTtChecked': false,
    'ShortNeoChecked': false,
    'ShortHwoChecked': false,
    'ShortConfChecked': false,
    'ShortDivergenceChecked': false,
    'ShortRevChecked': false,
    'ShortCatcherChecked': false,
    'ShortOscChecked': false,
    'ShortGretTcChecked': false,
    'ShortSigCrTtChecked': false,
    'M1ReversalPlusChecked': false,
    'M1ReversalChecked': false,
    'M1SignalExitChecked': false,
    'M1TcChangeChecked': false,
    'M2ReversalPlusChecked': false,
    'M2ReversalChecked': false,
    'M2SignalExitChecked': false,
    'M2TcChangeChecked': false,
    'M3ReversalPlusChecked': false,
    'M3ReversalChecked': false,
    'M3SignalExitChecked': false,
    'M3TcChangeChecked': false,
  };

  bool get isLongTcChecked => _values['LongTcChecked']!;
  bool get isLongTtChecked => _values['LongTtChecked']!;
  bool get isLongNeoChecked => _values['LongNeoChecked']!;
  bool get isLongHwoChecked => _values['LongHwoChecked']!;
  bool get isLongConfChecked => _values['LongConfChecked']!;
  bool get isLongDivergenceChecked => _values['LongDivergenceChecked']!;
  bool get isLongRevChecked => _values['LongRevChecked']!;
  bool get isLongCatcherChecked => _values['LongCatcherChecked']!;
  bool get isLongOscChecked => _values['LongOscChecked']!;
  bool get isLongGretTcChecked => _values['LongGretTcChecked']!;
  bool get isLongSigCrTtChecked => _values['LongSigCrTtChecked']!;

  bool get isShortTcChecked => _values['ShortTcChecked']!;
  bool get isShortTtChecked => _values['ShortTtChecked']!;
  bool get isShortNeoChecked => _values['ShortNeoChecked']!;
  bool get isShortHwoChecked => _values['ShortHwoChecked']!;
  bool get isShortConfChecked => _values['ShortConfChecked']!;
  bool get isShortDivergenceChecked => _values['ShortDivergenceChecked']!;
  bool get isShortRevChecked => _values['ShortRevChecked']!;
  bool get isShortCatcherChecked => _values['ShortCatcherChecked']!;
  bool get isShortOscChecked => _values['ShortOscChecked']!;
  bool get isShortGretTcChecked => _values['ShortGretTcChecked']!;
  bool get isShortSigCrTtChecked => _values['ShortSigCrTtChecked']!;

  bool get isM1ReversalPlusChecked => _values['M1ReversalPlusChecked']!;
  bool get isM1ReversalChecked => _values['M1ReversalChecked']!;
  bool get isM1SignalExitChecked => _values['M1SignalExitChecked']!;
  bool get isM1TcChangeChecked => _values['M1TcChangeChecked']!;
  bool get isM2ReversalPlusChecked => _values['M2ReversalPlusChecked']!;
  bool get isM2ReversalChecked => _values['M2ReversalChecked']!;
  bool get isM2SignalExitChecked => _values['M2SignalExitChecked']!;
  bool get isM2TcChangeChecked => _values['M2TcChangeChecked']!;
  bool get isM3ReversalPlusChecked => _values['M3ReversalPlusChecked']!;
  bool get isM3ReversalChecked => _values['M3ReversalChecked']!;
  bool get isM3SignalExitChecked => _values['M3SignalExitChecked']!;
  bool get isM3TcChangeChecked => _values['M3TcChangeChecked']!;

  bool get isM1LongAllChecked =>
      isLongTcChecked && isLongTtChecked && isLongNeoChecked && isLongHwoChecked && isLongConfChecked;

  bool get isM1ShortAllChecked =>
      isShortTcChecked && isShortTtChecked && isShortNeoChecked && isShortHwoChecked && isShortConfChecked;

  bool get isM2LongAllChecked =>
      (isLongDivergenceChecked || isLongRevChecked) && isLongCatcherChecked && isLongOscChecked;

  bool get isM2ShortAllChecked =>
      (isShortDivergenceChecked || isShortRevChecked) && isShortCatcherChecked && isShortOscChecked;

  bool get isM3LongAllChecked => isLongGretTcChecked && isLongSigCrTtChecked;

  bool get isM3ShortAllChecked => isShortGretTcChecked && isShortSigCrTtChecked;

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

  Future<void> _persist() async {
    if (_currentSymbol == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkbox_state:$_currentSymbol', jsonEncode(_values));
  }

  void changeValue(String method, String field, BuildContext context) {
    _values[field] = !(_values[field] ?? false);

    if (field.startsWith('Long')) {
      _values[field.replaceFirst('Long', 'Short')] = false;
    }
    if (field.startsWith('Short')) {
      _values[field.replaceFirst('Short', 'Long')] = false;
    }

    _persist();
    notifyListeners();
    if (field == 'M1ReversalPlusChecked' ||
        field == 'M1ReversalChecked' ||
        field == 'M1SignalExitChecked' ||
        field == 'M1TcChangeChecked') {
      final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
      final crnt = Provider.of<ValueProvider>(context, listen: false).currentOpening;
      var crntMod = crnt.firstWhere((el) => el.symbol == symbol && el.method == method);
      updateTradeFlags(crntMod, context);
    } else if (field == 'M2ReversalPlusChecked' ||
        field == 'M2ReversalChecked' ||
        field == 'M2SignalExitChecked' ||
        field == 'M2TcChangeChecked') {
      final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
      final crnt = Provider.of<ValueProvider>(context, listen: false).currentOpening;
      var crntMod = crnt.firstWhere((el) => el.symbol == symbol && el.method == method);
      updateTradeFlags(crntMod, context);
    } else if (field == 'M3ReversalPlusChecked' ||
        field == 'M3ReversalChecked' ||
        field == 'M3SignalExitChecked' ||
        field == 'M3TcChangeChecked') {
      final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
      final crnt = Provider.of<ValueProvider>(context, listen: false).currentOpening;
      var crntMod = crnt.firstWhere((el) => el.symbol == symbol && el.method == method);
      updateTradeFlags(crntMod, context);
    } else {
      return;
    }
  }

  void clearState() {
    _values = _emptyValues();
    _currentSymbol = null;
    notifyListeners();
  }
}
