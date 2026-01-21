import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import '../models/models.dart';

Future<void> updateTradeFlags(CurrentOpenModel mod, BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;

  if (symbol == null) return;

  final checked = Provider.of<CheckedBoxProvider>(context, listen: false);
  final valueProv = Provider.of<ValueProvider>(context, listen: false);

  final openTrade = valueProv.getOpenBySymbol(symbol);
  if (openTrade == null) return;

  late bool reversalPlus;
  late bool reversal;
  late bool signal;
  late bool tc;

  // sample
  if (mod.method == 'method1') {
    print("method1");
    reversalPlus = checked.isM1ReversalPlusChecked;
    reversal = checked.isM1ReversalChecked;
    signal = checked.isM1SignalExitChecked;
    tc = checked.isM1TcChangeChecked;
  } else if (mod.method == 'method2') {
    print("method2");
    reversalPlus = checked.isM2ReversalPlusChecked;
    reversal = checked.isM2ReversalChecked;
    signal = checked.isM2SignalExitChecked;
    tc = checked.isM2TcChangeChecked;
  } else if (mod.method == 'method3') {
    print("method3");
    reversalPlus = checked.isM3ReversalPlusChecked;
    reversal = checked.isM3ReversalChecked;
    signal = checked.isM3SignalExitChecked;
    tc = checked.isM3TcChangeChecked;
  }

  final data = {
    'symbol': symbol,
    'method': mod.method,
    'reversalPlus': reversalPlus,
    'reversal': reversal,
    'signalExit': signal,
    'tcChange': tc,
  };

  print(data);

  final dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)),
  );
  await dio.post(
    // 'http://13.201.225.85/trade/update-flags',
    'http://localhost:4000/trade/update-flags',
    // data: {
    //   'symbol': symbol,
    //   'reversalPlus': checked.isReversalPlusChecked,
    //   'reversal': checked.isReversalChecked,
    //   'signalExit': checked.isSignalExitChecked,
    //   'tcChange': checked.isTcChangeChecked,
    // },
    data: data,
    options: Options(headers: {'auth-token': token}),
  );

  // update local cache
  // valueProv.updateFlags(symbol, checked.isReversalPlusChecked, checked.isSignalExitChecked, checked.isTcChangeChecked);
  valueProv.updateFlags(symbol, reversalPlus, reversal, signal, tc);
}
