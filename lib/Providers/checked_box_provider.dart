import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auditplus_fx/Providers/value_provider.dart';

import '../api_methods/api_methods.dart';
import '../models/models.dart';

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
    'MM1ReversalPlusChecked': false,
    'MM1ReversalChecked': false,
    'MM1SignalExitChecked': false,
    'MM1TcChangeChecked': false,
    'MM1HwChecked': false,
    'MM1MfChecked': false,
    'MM2ReversalPlusChecked': false,
    'MM2ReversalChecked': false,
    'MM2SignalExitChecked': false,
    'MM2TcChangeChecked': false,
    'MM2HwChecked': false,
    'MM2MfChecked': false,
    //Auto Booking & Closing
    'AM1Checked': false,
    'AM2Checked': false,
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

  bool get isMM1ReversalPlusChecked => _values['MM1ReversalPlusChecked']!;
  bool get isMM1ReversalChecked => _values['MM1ReversalChecked']!;
  bool get isMM1SignalExitChecked => _values['MM1SignalExitChecked']!;
  bool get isMM1TcChangeChecked => _values['MM1TcChangeChecked']!;
  bool get isMM1HwChecked => _values['MM1HwChecked']!;
  bool get isMM1MfChecked => _values['MM1MfChecked']!;
  bool get isMM2ReversalPlusChecked => _values['MM2ReversalPlusChecked']!;
  bool get isMM2ReversalChecked => _values['MM2ReversalChecked']!;
  bool get isMM2SignalExitChecked => _values['MM2SignalExitChecked']!;
  bool get isMM2TcChangeChecked => _values['MM2TcChangeChecked']!;
  bool get isMM2HwChecked => _values['MM2HwChecked']!;
  bool get isMM2MfChecked => _values['MM2MfChecked']!;

  //Auto Booking & Closing
  bool get isAM1Checked => _values['AM1Checked']!;
  bool get isAM2Checked => _values['AM2Checked']!;

  bool get isM1LongAllChecked =>
      isLongTcChecked &&
      isLongTtChecked &&
      isLongNeoChecked &&
      isLongHwoChecked &&
      isLongConfChecked;

  bool get isM1ShortAllChecked =>
      isShortTcChecked &&
      isShortTtChecked &&
      isShortNeoChecked &&
      isShortHwoChecked &&
      isShortConfChecked;

  bool get isM2LongAllChecked =>
      (isLongDivergenceChecked || isLongRevChecked) &&
      isLongCatcherChecked &&
      isLongOscChecked;

  bool get isM2ShortAllChecked =>
      (isShortDivergenceChecked || isShortRevChecked) &&
      isShortCatcherChecked &&
      isShortOscChecked;

  // Future<void> loadForSymbol(String symbol) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   _currentSymbol = symbol;
  //   final prefs = await SharedPreferences.getInstance();
  //   final data = prefs.getString('checkbox_state:$symbol');
  //   if (data == null) {
  //     _values = _emptyValues();
  //   } else {
  //     final decoded = Map<String, dynamic>.from(jsonDecode(data));
  //     _values = decoded.map((k, v) => MapEntry(k, v as bool));
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }
  // Future<void> loadForM3Values(BuildContext context) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? data = prefs.getString('AutomateCurrentOpening');
  //   if (data != null) {
  //     final Map<String, dynamic> am1Decoded = jsonDecode(data);
  //     if (!context.mounted) return;
  //     final prov = Provider.of<ValueProvider>(context, listen: false);
  //     prov.lastAMOpen = CurrentAutomationModel.fromJson(am1Decoded);
  //     prov.amSelectedValue = prov.lastAMOpen!.symbol;
  //     prov.amSelectedItem = SearchFieldListItem(
  //       prov.amSelectedValue!,
  //       item: prov.amSelectedValue,
  //     );
  //     prov.am1VolumeController.text = prov.lastAMOpen!.volume.toString();
  //     // _values['AM1Checked'] = prov.lastAMOpen!.isChecked;
  //     _values['AM1Checked'] = prov.lastAMOpen!.isEnabled;
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }
  Future<void> loadFromApi(String symbol, String section) async {
  _isLoading = true;
  notifyListeners();

  _currentSymbol = symbol;

  try {
    final result = await getSymbolSetting(
      symbol: symbol,
      section: section,
    );

    // ✅ FIX: merge instead of overwrite
    result.forEach((key, value) {
      _values[key] = value;
    });

  } catch (e) {
    _values = _emptyValues();
  }

  _isLoading = false;
  notifyListeners();
}
  // Future<void> _persist() async {
  //   if (_currentSymbol == null) return;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(
  //     'checkbox_state:$_currentSymbol',
  //     jsonEncode(_values),
  //   );
  // }

  void changeValue(
    String? action,
    String method,
    String field,
    BuildContext context,
  ) {
    _values[field] = !(_values[field] ?? false);

    if (field.startsWith('Long')) {
      _values[field.replaceFirst('Long', 'Short')] = false;
    }
    if (field.startsWith('Short')) {
      _values[field.replaceFirst('Short', 'Long')] = false;
    }
    if (method == 'AM1') {
      _values[field] = _values[field]!;
    }
    if (method == 'AM2') {
      _values[field] = _values[field]!;
    }

    symbolSetting(
      symbol: _currentSymbol!,
      section: method, // MM1 / MM2
      checkedValues: _values,
    );

    // _persist();
    notifyListeners();
    if (field == 'MM1ReversalPlusChecked' ||
        field == 'MM1ReversalChecked' ||
        field == 'MM1SignalExitChecked' ||
        field == 'MM1TcChangeChecked' ||
        field == 'MM1HwChecked' ||
        field == 'MM1MfChecked') {
      final symbol = Provider.of<ValueProvider>(
        context,
        listen: false,
      ).selectedValue;
      final crnt = Provider.of<ValueProvider>(
        context,
        listen: false,
      ).currentOpening;
      var crntMod = crnt.firstWhere(
        (el) => el.symbol == symbol && el.method == method,
      );
      updateTradeFlags(crntMod, context);
    } else if (field == 'MM2ReversalPlusChecked' ||
        field == 'MM2ReversalChecked' ||
        field == 'MM2SignalExitChecked' ||
        field == 'MM2TcChangeChecked' ||
        field == 'MM2HwChecked' ||
        field == 'MM2MfChecked') {
      final symbol = Provider.of<ValueProvider>(
        context,
        listen: false,
      ).selectedValue;
      final crnt = Provider.of<ValueProvider>(
        context,
        listen: false,
      ).currentOpening;
      var crntMod = crnt.firstWhere(
        (el) => el.symbol == symbol && el.method == method,
      );
      updateTradeFlags(crntMod, context);
    } else if (field == 'AM1Checked' || field == 'AM2Checked') {
      final valProv = Provider.of<ValueProvider>(context, listen: false);
      final symbol = valProv.amSelectedValue;
      print(field);
      if (field == 'AM1Checked') {
        final volume = valProv.am1Volume;
        // final data = CurrentAutomationModel(method: method, symbol: symbol!, volume: volume, isChecked: isAM1Checked);
        final data = CurrentAutomationModel(
          method: method,
          symbol: symbol!,
          volume: volume,
          isEnabled: isAM1Checked,
          action: action!,
        );
        automaticTrading(context, data);
      } else {
        final volume = valProv.am2Volume;
        // final data = CurrentAutomationModel(method: method, symbol: symbol!, volume: volume, isChecked: isAM2Checked);
        final data = CurrentAutomationModel(
          method: method,
          symbol: symbol!,
          volume: volume,
          isEnabled: isAM2Checked,
          action: action!,
        );
        automaticTrading(context, data);
      }
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
