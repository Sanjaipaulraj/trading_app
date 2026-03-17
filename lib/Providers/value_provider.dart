import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auditplus_fx/Providers/checked_box_provider.dart';
import '../models/models.dart';

class ValueProvider extends ChangeNotifier {
  String? selectedValue;
  String? m3SelectedValue;
  bool isAutomaticEnabled = false;
  SearchFieldListItem<String>? selectedItem;
  SearchFieldListItem<String>? m3SelectedItem;
  num volume = 0.01;
  num m3Volume = 0.01;
  final TextEditingController volumeController = TextEditingController();
  final TextEditingController m3VolumeController = TextEditingController();

  bool _isLoading = true;
  Set<CurrentOpenModel> currentOpening = {};
  SearchFieldListItem<String>? lastActiveSymbol;
  CurrentMethod3Model? lastM3Open;
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

    volume = prefs.getDouble('volume') ?? 0.01;
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

  void setAutomaticEnable() {
    isAutomaticEnabled = !isAutomaticEnabled;
    notifyListeners();
  }

  void setVolume(double newVolume) async {
    volume = newVolume;
    volumeController.text = newVolume.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', newVolume);
    notifyListeners();
  }

  void setM3Volume(double newVolume) async {
    m3Volume = newVolume;
    m3VolumeController.text = newVolume.toString();
    notifyListeners();
  }

  void clearSelectedValue() {
    selectedValue = null;
    selectedItem = null;
    notifyListeners();
  }

  void m3ClearSelectedValue() {
    m3SelectedValue = null;
    m3SelectedItem = null;
    notifyListeners();
  }

  void setSelectedItem(SearchFieldListItem<String> item, BuildContext context) async {
    selectedItem = item;
    selectedValue = item.searchKey;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastActiveSymbol', item.searchKey);

    notifyListeners();
  }

  void setM3SelectedItem(SearchFieldListItem<String> item, BuildContext context) async {
    m3SelectedItem = item;
    m3SelectedValue = item.searchKey;

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

  void updateFlags(String symbol, bool rp, bool r, bool s, bool t, bool hw) {
    final open = getOpenBySymbol(symbol);
    if (open != null) {
      open.reversalPlus = rp;
      open.reversal = r;
      open.signalExit = s;
      open.tcChange = t;
      open.hyperWave = hw;
      notifyListeners();
    }
  }
}
