import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/models/active_symbol_model.dart';
import 'package:trading_app/models/current_open_model.dart';

class ValueProvider extends ChangeNotifier {
  String? selectedValue;
  SearchFieldListItem<String>? selectedItem;
  num volume = 1.03;
  final TextEditingController volumeController = TextEditingController();
  bool _isLoading = true;
  Set<CurrentOpenModel> currentOpening = {};
  SearchFieldListItem<String>? lastActiveSymbol;
  List<ActiveSymbolModel> liveSymbols = [];

  bool get isLoading => _isLoading;

  ValueProvider(BuildContext context) {
    _loadVolume(context);
  }

  @override
  void dispose() {
    volumeController.dispose();
    super.dispose();
  }

  Future<void> _loadVolume(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    volume = prefs.getDouble('volume') ?? 1.03;
    volumeController.text = volume.toString();
    final decoded = jsonDecode(prefs.getString('currentOpening') ?? '[]') as List;

    currentOpening = decoded.map((e) => CurrentOpenModel.fromJson(e)).toSet();

    final lastSymbol = prefs.getString('lastActiveSymbol');
    if (lastSymbol != null) {
      selectedValue = lastSymbol;
      selectedItem = SearchFieldListItem<String>(lastSymbol, item: lastSymbol);
      // ignore: use_build_context_synchronously
      Provider.of<CheckedBoxProvider>(context, listen: false).loadForSymbol(selectedValue!);
    }
    _isLoading = false;
    notifyListeners();
  }

  void setVolume(double newVolume) async {
    volume = newVolume;
    volumeController.text = newVolume.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', newVolume);
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

  void setSelectedItem(SearchFieldListItem<String> item, BuildContext context) async {
    selectedItem = item;
    selectedValue = item.searchKey;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastActiveSymbol', item.searchKey);

    notifyListeners();
  }

  void addCurrentOpen(CurrentOpenModel symb) async {
    currentOpening.add(symb);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(currentOpening.map((e) => e.toJson()).toList());

    await prefs.setString('currentOpening', encoded);
  }

  Future<void> clearCurrentOpenBySymbol(String symbol) async {
    currentOpening.removeWhere((e) => e.symbol == symbol);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(currentOpening.map((e) => e.toJson()).toList());

    await prefs.setString('currentOpening', encoded);
  }

  CurrentOpenModel? getOpenBySymbol(String symbol) {
    try {
      return currentOpening.firstWhere((e) => e.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  void updateFlags(String symbol, bool r, bool s, bool t) {
    final open = getOpenBySymbol(symbol);
    if (open != null) {
      open.reversalPlus = r;
      open.signalExit = s;
      open.tcChange = t;
      notifyListeners();
    }
  }

  void updateFetchSymbols(List<ActiveSymbolModel> symbolList) {
    liveSymbols = symbolList;
    notifyListeners();
  }
}
