import 'dart:convert';

import 'package:auditplus_fx/api_methods/local_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:auditplus_fx/Providers/checked_box_provider.dart';
import '../models/models.dart';

class ValueProvider extends ChangeNotifier {
  String? manualSelectedValue;
  String? amSelectedValue;
  bool isAutomaticSectionEnabled = false;
  SearchFieldListItem<String>? manualSelectedItem;
  SearchFieldListItem<String>? amSelectedItem;
  num manualVolume = 0.01;
  num amVolume = 0.01;
  final TextEditingController manualVolumeController = TextEditingController();
  final TextEditingController amVolumeController = TextEditingController();

  bool _isLoading = true;
  Set<CurrentOpenModel> currentOpening = {};
  SearchFieldListItem<String>? lastActiveSymbol;
  CurrentAutomationModel? lastAMOpen;
  bool get isLoading => _isLoading;

  ValueProvider(BuildContext context) {
    // _loadVolume(context);
    _loadInitial(context);
  }

  @override
  void dispose() {
    manualVolumeController.dispose();
    super.dispose();
  }

  // Future<void> _loadVolume(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   volume = prefs.getDouble('volume') ?? 0.01;
  //   volumeController.text = volume.toString();
  //   final decoded = jsonDecode(prefs.getString('currentOpening') ?? '[]') as List;
  //   currentOpening = decoded.map((e) => CurrentOpenModel.fromJson(e)).toSet();
  //   final lastSymbol = prefs.getString('lastActiveSymbol');
  //   if (lastSymbol != null) {
  //     selectedValue = lastSymbol;
  //     selectedItem = SearchFieldListItem<String>(lastSymbol, item: lastSymbol);
  //     // Provider.of<CheckedBoxProvider>(context, listen: false).loadForSymbol(selectedValue!);
  //     // ignore: use_build_context_synchronously
  //     Provider.of<CheckedBoxProvider>(context, listen: false).loadFromApi(selectedValue!,'MM');
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> _loadInitial(BuildContext context) async {
    final response = await getLocalValues();
    print(response);
    manualVolume = response.manualVolume;
    manualVolumeController.text = manualVolume.toString();
    amVolume = response.automaticVolume;
    amVolumeController.text = amVolume.toString();
    final lastSymbol = response.lastActiveSymbol;
    if (lastSymbol != "") {
      manualSelectedValue = lastSymbol;
      manualSelectedItem = SearchFieldListItem<String>(
        lastSymbol,
        item: lastSymbol,
      );
    }
    _isLoading = false;

    notifyListeners();
  }

  void setAutomaticEnable() {
    isAutomaticSectionEnabled = !isAutomaticSectionEnabled;
    notifyListeners();
  }

  void setManualVolume(double newVolume) async {
    manualVolume = newVolume;
    manualVolumeController.text = newVolume.toString();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setDouble('volume', newVolume);
    notifyListeners();
  }

  void setAMVolume(String method, double newVolume) async {
    // if (method == 'AM1') {
    amVolume = newVolume;
    amVolumeController.text = newVolume.toString();
    notifyListeners();
    // } else {
    // am2Volume = newVolume;
    // am2VolumeController.text = newVolume.toString();
    // notifyListeners();
    // }
  }

  void clearSelectedValue() {
    manualSelectedValue = null;
    manualSelectedItem = null;
    notifyListeners();
  }

  void amClearSelectedValue() {
    amSelectedValue = null;
    amSelectedItem = null;
    notifyListeners();
  }

  void setSelectedItem(
    SearchFieldListItem<String> item,
    BuildContext context,
  ) async {
    manualSelectedItem = item;
    manualSelectedValue = item.searchKey;

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('lastActiveSymbol', item.searchKey);
    notifyListeners();
  }

  void setAMSelectedItem(
    SearchFieldListItem<String> item,
    BuildContext context,
  ) async {
    amSelectedItem = item;
    amSelectedValue = item.searchKey;

    notifyListeners();
  }

  void addCurrentOpen(CurrentOpenModel symb) async {
    currentOpening.add(symb);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(currentOpening.map((e) => e.toJson()).toList());
    print(encoded);

    // await prefs.setString('currentOpening', encoded);
  }

  Future<void> clearCurrentOpenBySymbol(String symbol) async {
    currentOpening.removeWhere((e) => e.symbol == symbol);

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(currentOpening.map((e) => e.toJson()).toList());
    print(encoded);

    // await prefs.setString('currentOpening', encoded);
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
