import 'dart:convert';

import 'package:auditplus_fx/api_methods/local_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'providers.dart';

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

  //New
  List<LiveAutomaticTradeModel> liveAutomaticTrade = [];

  ValueProvider(BuildContext context) {
    _loadInitial(context);
  }

  @override
  void dispose() {
    manualVolumeController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial(BuildContext context) async {
    final response = await getLocalValues();
    manualVolume = response.manualVolume;
    manualVolumeController.text = manualVolume.toString();
    amVolume = response.automaticVolume;
    amVolumeController.text = amVolume.toString();
    final lastSymbol = response.lastActiveSymbol;
    final amLastSymbol = response.amLastSymbol;
    liveAutomaticTrade = response.liveAutomaticTrade;
    if (lastSymbol.isNotEmpty) {
      manualSelectedValue = lastSymbol;
      manualSelectedItem = SearchFieldListItem<String>(lastSymbol, item: lastSymbol);

      // 🔥 IMPORTANT: Load checkbox state AFTER symbol is set
      Future.microtask(() {
        if (!context.mounted) return;

        final checkboxProvider = Provider.of<CheckedBoxProvider>(context, listen: false);

        checkboxProvider.loadFromApi(lastSymbol, 'MM');
        checkboxProvider.loadFromApi(lastSymbol, 'AM');
      });
    }
    if (amLastSymbol.isNotEmpty) {
      amSelectedValue = amLastSymbol;
      amSelectedItem = SearchFieldListItem<String>(amLastSymbol, item: amLastSymbol);

      Future.microtask(() {
        if (!context.mounted) return;

        final checkboxProvider = Provider.of<CheckedBoxProvider>(context, listen: false);

        checkboxProvider.loadFromApi(lastSymbol, 'MM');
        checkboxProvider.loadFromApi(lastSymbol, 'AM');
      });
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

    final data = LocalValuesModel(
      userId: "1",
      lastActiveSymbol: manualSelectedValue ?? "",
      amLastSymbol: amSelectedValue ?? "",
      automaticVolume: amVolume,
      manualVolume: manualVolume,
      liveAutomaticTrade: liveAutomaticTrade,
    );
    await setLocalValues(data);
    notifyListeners();
  }

  void setAMVolume(String method, double newVolume) async {
    // if (method == 'AM1') {
    amVolume = newVolume;
    amVolumeController.text = newVolume.toString();

    final data = LocalValuesModel(
      userId: "1",
      lastActiveSymbol: manualSelectedValue ?? "",
      amLastSymbol: amSelectedValue ?? "",
      automaticVolume: amVolume,
      manualVolume: manualVolume,
      liveAutomaticTrade: liveAutomaticTrade,
    );
    await setLocalValues(data);
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

  void setSelectedItem(SearchFieldListItem<String> item, BuildContext context) async {
    manualSelectedItem = item;
    manualSelectedValue = item.searchKey;

    final data = LocalValuesModel(
      userId: "1",
      lastActiveSymbol: manualSelectedValue ?? "",
      amLastSymbol: amSelectedValue ?? "",
      automaticVolume: amVolume,
      manualVolume: manualVolume,
      liveAutomaticTrade: liveAutomaticTrade,
    );
    await setLocalValues(data);
    notifyListeners();
  }

  void setAMSelectedItem(SearchFieldListItem<String> item, BuildContext context) async {
    amSelectedItem = item;
    amSelectedValue = item.searchKey;

    final data = LocalValuesModel(
      userId: "1",
      lastActiveSymbol: manualSelectedValue ?? "",
      amLastSymbol: amSelectedValue ?? "",
      automaticVolume: amVolume,
      manualVolume: manualVolume,
      liveAutomaticTrade: liveAutomaticTrade,
    );
    await setLocalValues(data);

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

  void removeLiveTrade(String symbol) {
    liveAutomaticTrade.removeWhere((el) => el.symbol == symbol);
    notifyListeners();
  }

  void addLiveTrade(CurrentAutomationModel mod) {
    liveAutomaticTrade.add(LiveAutomaticTradeModel(symbol: mod.symbol, volume: mod.volume));
    notifyListeners();
  }
}
