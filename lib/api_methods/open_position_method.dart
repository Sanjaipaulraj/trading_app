// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import 'package:auditplus_fx/api_methods/api_methods.dart';
import '../models/models.dart';
import 'contants.dart';

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
  late bool hw;
  late bool mf;

  if (method == 'MM1') {
    final prov = Provider.of<ValueProvider>(context, listen: false);
    final symbol = prov.selectedValue;
    final Set<CurrentOpenModel> crntOpen = prov.currentOpening;
    for (final model in crntOpen) {
      if (model.symbol != symbol) continue;

      if (model.method == 'MM2') {
        if (model.actionType != actionType) {
          await onClosePosition(context, "POSITION_CLOSE_ID");
          break;
        }
      }
    }
    reversalPlus = checkedProv.isMM1ReversalPlusChecked;
    reversal = checkedProv.isMM1ReversalChecked;
    signal = checkedProv.isMM1SignalExitChecked;
    tc = checkedProv.isMM1TcChangeChecked;
    hw = checkedProv.isMM1HwChecked;
    mf = checkedProv.isMM1MfChecked;
  } else if (method == 'MM2') {
    final prov = Provider.of<ValueProvider>(context, listen: false);
    final symbol = prov.selectedValue;
    final Set<CurrentOpenModel> crntOpen = prov.currentOpening;
    for (final model in crntOpen) {
      if (model.symbol != symbol) continue;

      if (model.method == 'MM1') {
        if (model.actionType != actionType) {
          await onClosePosition(context, "POSITION_CLOSE_ID");
          break;
        }
      }
    }
    reversalPlus = checkedProv.isMM2ReversalPlusChecked;
    reversal = checkedProv.isMM2ReversalChecked;
    signal = checkedProv.isMM2SignalExitChecked;
    tc = checkedProv.isMM2TcChangeChecked;
    hw = checkedProv.isMM2HwChecked;
    mf = checkedProv.isMM2MfChecked;
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
    hyperWave: hw,
    moneyFlow: mf,
  );
  try {
    final _ = await dio.post(
      "$url/open",
      data: jsonEncode(data),
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );

    late bool reversalPlus;
    late bool reversal;
    late bool signal;
    late bool tc;
    late bool hw;

    if (method == 'MM1') {
      reversalPlus = checkedProv.isMM1ReversalPlusChecked;
      reversal = checkedProv.isMM1ReversalChecked;
      signal = checkedProv.isMM1SignalExitChecked;
      tc = checkedProv.isMM1TcChangeChecked;
      hw = checkedProv.isMM1HwChecked;
    } else if (method == 'MM2') {
      reversalPlus = checkedProv.isMM2ReversalPlusChecked;
      reversal = checkedProv.isMM2ReversalChecked;
      signal = checkedProv.isMM2SignalExitChecked;
      tc = checkedProv.isMM2TcChangeChecked;
      hw = checkedProv.isMM2HwChecked;
    }

    final mod = CurrentOpenModel(
      symbol: symbol!,
      method: data.method!,
      actionType: actionType,
      reversalPlus: reversalPlus,
      reversal: reversal,
      signalExit: signal,
      tcChange: tc,
      hyperWave: hw,
      moneyFlow: mf,
    );
    Provider.of<ValueProvider>(context, listen: false).addCurrentOpen(mod);
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
