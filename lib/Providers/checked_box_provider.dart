import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/models/current_open_model.dart';

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

  void changeValue(String field, BuildContext context) {
    _values[field] = !(_values[field] ?? false);

    if (field.startsWith('Long')) {
      _values[field.replaceFirst('Long', 'Short')] = false;
    }
    if (field.startsWith('Short')) {
      _values[field.replaceFirst('Short', 'Long')] = false;
    }

    _persist();
    notifyListeners();
    if (field == 'ReversalPlusChecked' || field == 'SignalExitChecked' || field == 'TcChangeChecked') {
      final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
      final crnt = Provider.of<ValueProvider>(context, listen: false).currentOpening;
      var crntMod = crnt.firstWhere((el) => el.symbol == symbol);
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

Future<void> updateTradeFlags(CurrentOpenModel mod, BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;

  if (symbol == null) return;

  final checked = Provider.of<CheckedBoxProvider>(context, listen: false);
  final valueProv = Provider.of<ValueProvider>(context, listen: false);

  final openTrade = valueProv.getOpenBySymbol(symbol);
  if (openTrade == null) return;

  final dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),
  );
  await dio.post(
    'http://13.201.225.85/trade/update-flags',
    data: {
      'symbol': symbol,
      'reversalPlus': checked.isReversalPlusChecked,
      'signalExit': checked.isSignalExitChecked,
      'tcChange': checked.isTcChangeChecked,
    },
    options: Options(headers: {'auth-token': token}),
  );

  // update local cache
  valueProv.updateFlags(symbol, checked.isReversalPlusChecked, checked.isSignalExitChecked, checked.isTcChangeChecked);
}
