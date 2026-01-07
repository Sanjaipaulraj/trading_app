// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import '../models/models.dart';

Future<void> openPosition(String actionType, num? takeProfit, BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  if (token == null) {
    toastification.show(
      backgroundColor: Color.fromRGBO(242, 186, 185, 1),
      title: const Text('Error!'),
      description: const Text('Token is empty!'),
      type: ToastificationType.error,
      alignment: Alignment.center,
      autoCloseDuration: const Duration(seconds: 2),
    );
    return;
  }

  Dio dio = Dio();
  final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
  final volume = Provider.of<ValueProvider>(context, listen: false).volume;
  final reversalPlus = Provider.of<CheckedBoxProvider>(context, listen: false).isReversalPlusChecked;
  final reversal = Provider.of<CheckedBoxProvider>(context, listen: false).isReversalChecked;
  final signal = Provider.of<CheckedBoxProvider>(context, listen: false).isSignalExitChecked;
  final tc = Provider.of<CheckedBoxProvider>(context, listen: false).isTcChangeChecked;
  final data = OpenRequestModel(
    actionType: actionType,
    symbol: symbol,
    volume: volume,
    takeProfit: takeProfit,
    reversalPlus: reversalPlus,
    reversal: reversal,
    signalExit: signal,
    tcChange: tc,
  );
  try {
    final _ = await dio.post(
      'http://13.201.225.85/trade/open',
      // 'http://localhost:4000/trade/open',
      data: jsonEncode(data),
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );

    final reversal = Provider.of<CheckedBoxProvider>(context, listen: false).isReversalPlusChecked;
    final signal = Provider.of<CheckedBoxProvider>(context, listen: false).isSignalExitChecked;
    final tc = Provider.of<CheckedBoxProvider>(context, listen: false).isTcChangeChecked;
    final mod = CurrentOpenModel(symbol: symbol!, reversalPlus: reversal, signalExit: signal, tcChange: tc);
    Provider.of<ValueProvider>(context, listen: false).addCurrentOpen(mod);
    // ✅ Only 2xx responses reach here
    // toastification.show(
    //   backgroundColor: const Color.fromARGB(55, 172, 221, 159),
    //   title: const Text('Success!'),
    //   description: const Text('Send successfully'),
    //   type: ToastificationType.success,
    //   alignment: Alignment.center,
    //   autoCloseDuration: Duration(seconds: 1),
    // );
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 409) {
      toastification.show(
        backgroundColor: const Color.fromARGB(255, 240, 230, 174),
        title: Text('${e.response?.data}'),
        description: Text(e.response!.data),
        type: ToastificationType.warning,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else if (statusCode == 401) {
      toastification.show(
        backgroundColor: const Color.fromARGB(255, 242, 186, 185),
        title: Text('${e.response?.data}'),
        description: const Text('Token not Valid'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.show(
        backgroundColor: const Color.fromARGB(255, 242, 186, 185),
        title: const Text('Error!'),
        description: Text('Status code: $statusCode\n${e.message}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    toastification.show(
      backgroundColor: const Color.fromRGBO(255, 242, 186, 185),
      title: const Text('Unexpected Error!'),
      description: Text(e.toString()),
      type: ToastificationType.error,
      alignment: Alignment.center,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}
