import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/models/current_open_model.dart';

Future<void> updateTradeFlags(CurrentOpenModel mod, BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;

  if (symbol == null) return;

  final checked = Provider.of<CheckedBoxProvider>(context, listen: false);
  final valueProv = Provider.of<ValueProvider>(context, listen: false);

  final openTrade = valueProv.getOpenBySymbol(symbol);
  if (openTrade == null) return;

  final dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)),
  );
  await dio.post(
    'http://13.201.225.85/trade/update-flags',
    // 'http://localhost:4000/trade/update-flags',
    data: {
      'symbol': symbol,
      'reversalPlus': checked.isReversalPlusChecked,
      'reversal': checked.isReversalChecked,
      'signalExit': checked.isSignalExitChecked,
      'tcChange': checked.isTcChangeChecked,
    },
    options: Options(headers: {'auth-token': token}),
  );

  // update local cache
  valueProv.updateFlags(symbol, checked.isReversalPlusChecked, checked.isSignalExitChecked, checked.isTcChangeChecked);
}
