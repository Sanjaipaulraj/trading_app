// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/checked_box_provider.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/api_methods/api_methods.dart';
import '../models/models.dart';

Future<void> openPosition(String method, String actionType, num? takeProfit, BuildContext context) async {
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
  final valueProv = Provider.of<ValueProvider>(context, listen: false);
  final checkedProv = Provider.of<CheckedBoxProvider>(context, listen: false);
  final symbol = valueProv.selectedValue;
  final volume = valueProv.volume;
  late bool reversalPlus;
  late bool reversal;
  late bool signal;
  late bool tc;

  if (method == 'method1') {
    final prov = Provider.of<ValueProvider>(context, listen: false);
    final symbol = prov.selectedValue;
    final Set<CurrentOpenModel> crntOpen = prov.currentOpening;
    for (final model in crntOpen) {
      if (model.symbol != symbol) continue;

      if (model.method == 'method2' || model.method == 'method3') {
        if (model.actionType != actionType) {
          await onClosePosition(context, "POSITIONS_CLOSE_SYMBOL");
          break;
        }
      }
    }
    reversalPlus = checkedProv.isM1ReversalPlusChecked;
    reversal = checkedProv.isM1ReversalChecked;
    signal = checkedProv.isM1SignalExitChecked;
    tc = checkedProv.isM1TcChangeChecked;
  } else if (method == 'method2') {
    final prov = Provider.of<ValueProvider>(context, listen: false);
    final symbol = prov.selectedValue;
    final Set<CurrentOpenModel> crntOpen = prov.currentOpening;
    for (final model in crntOpen) {
      if (model.symbol != symbol) continue;

      if (model.method == 'method1' || model.method == 'method3') {
        if (model.actionType != actionType) {
          await onClosePosition(context, "POSITIONS_CLOSE_SYMBOL");
          break;
        }
      }
    }
    reversalPlus = checkedProv.isM2ReversalPlusChecked;
    reversal = checkedProv.isM2ReversalChecked;
    signal = checkedProv.isM2SignalExitChecked;
    tc = checkedProv.isM2TcChangeChecked;
  } else if (method == 'method3') {
    final prov = Provider.of<ValueProvider>(context, listen: false);
    final symbol = prov.selectedValue;
    final Set<CurrentOpenModel> crntOpen = prov.currentOpening;
    for (final model in crntOpen) {
      if (model.symbol != symbol) continue;

      if (model.method == 'method1' || model.method == 'method2') {
        if (model.actionType != actionType) {
          await onClosePosition(context, "POSITIONS_CLOSE_SYMBOL");
          break;
        }
      }
    }
    reversalPlus = checkedProv.isM3ReversalPlusChecked;
    reversal = checkedProv.isM3ReversalChecked;
    signal = checkedProv.isM3SignalExitChecked;
    tc = checkedProv.isM3TcChangeChecked;
  }

  final data = OpenRequestModel(
    actionType: actionType,
    symbol: symbol,
    method: method,
    volume: volume,
    takeProfit: takeProfit,
    reversalPlus: reversalPlus,
    reversal: reversal,
    signalExit: signal,
    tcChange: tc,
  );
  try {
    final _ = await dio.post(
      // 'http://13.201.225.85/trade/open',
      'http://localhost:4000/trade/open',
      data: jsonEncode(data),
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );

    late bool reversalPlus;
    late bool reversal;
    late bool signal;
    late bool tc;

    if (method == 'method1') {
      reversalPlus = checkedProv.isM1ReversalPlusChecked;
      reversal = checkedProv.isM1ReversalChecked;
      signal = checkedProv.isM1SignalExitChecked;
      tc = checkedProv.isM1TcChangeChecked;
    } else if (method == 'method2') {
      reversalPlus = checkedProv.isM2ReversalPlusChecked;
      reversal = checkedProv.isM2ReversalChecked;
      signal = checkedProv.isM2SignalExitChecked;
      tc = checkedProv.isM2TcChangeChecked;
    } else if (method == 'method3') {
      reversalPlus = checkedProv.isM3ReversalPlusChecked;
      reversal = checkedProv.isM3ReversalChecked;
      signal = checkedProv.isM3SignalExitChecked;
      tc = checkedProv.isM3TcChangeChecked;
    }

    final mod = CurrentOpenModel(
      symbol: symbol!,
      method: data.method!,
      actionType: actionType,
      reversalPlus: reversalPlus,
      reversal: reversal,
      signalExit: signal,
      tcChange: tc,
    );
    Provider.of<ValueProvider>(context, listen: false).addCurrentOpen(mod);
    // Only 2xx responses reach here
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
