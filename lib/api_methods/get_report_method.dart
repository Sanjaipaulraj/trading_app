import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/Providers/value_provider.dart';
import 'package:trading_app/models/get_report_model.dart';

Future<void> getReport(BuildContext context) async {
  final provider = Provider.of<ValueProvider>(context, listen: false);
  final String symbol = provider.menuSelectedValue;
  final String startDate = provider.startDate!;
  final String endDate = provider.endDate!;
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
  final dio = Dio();
  final data = GetReportModel(symbol: symbol, startDate: startDate, endDate: endDate);
  print(jsonEncode(data));
  try {
    final response = dio.post(
      // 'http://13.201.225.85/trade/report',
      'http://localhost:4000/trade/report',
      data: jsonEncode(data),
    );
    print(response);
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
