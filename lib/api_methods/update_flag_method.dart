import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import '../models/models.dart';
import 'contants.dart';

Future<void> updateTradeFlags(CurrentOpenModel mod, BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  // final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
  final symbol = Provider.of<ValueProvider>(context, listen: false).manualSelectedValue;

  if (symbol == null) return;

  final checked = Provider.of<CheckedBoxProvider>(context, listen: false);
  final valueProv = Provider.of<ValueProvider>(context, listen: false);

  final openTrade = valueProv.getOpenBySymbol(symbol);
  if (openTrade == null) return;

  late bool reversalPlus;
  late bool reversal;
  late bool signal;
  late bool tc;
  late bool hw;
  late bool mf;

  if (mod.method == 'MM1') {
    reversalPlus = checked.isMM1ReversalPlusChecked;
    reversal = checked.isMM1ReversalChecked;
    signal = checked.isMM1SignalExitChecked;
    tc = checked.isMM1TcChangeChecked;
    hw = checked.isMM1HwChecked;
    mf = checked.isMM1MfChecked;
  } else if (mod.method == 'MM2') {
    reversalPlus = checked.isMM2ReversalPlusChecked;
    reversal = checked.isMM2ReversalChecked;
    signal = checked.isMM2SignalExitChecked;
    tc = checked.isMM2TcChangeChecked;
    hw = checked.isMM2HwChecked;
    mf = checked.isMM2MfChecked;
  }

  final data = {
    'symbol': symbol,
    'method': mod.method,
    'reversalPlus': reversalPlus,
    'reversal': reversal,
    'signalExit': signal,
    'tcChange': tc,
    'hyperWave': hw,
    'moneyFlow': mf,
  };

  final dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)),
  );
  await dio.post(
    '$url/update-flags',
    data: data,
    options: Options(headers: {'auth-token': token}),
  );

  // update local cache
  valueProv.updateFlags(symbol, reversalPlus, reversal, signal, tc, hw);
}
