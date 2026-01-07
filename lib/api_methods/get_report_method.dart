import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/token_provider.dart';
import 'package:trading_app/create_report.dart';
import '../models/models.dart';

Future<void> getReport(BuildContext context, String symbol, String startDate, String endDate) async {
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
  try {
    final response = await dio.post(
      'http://13.201.225.85/trade/report',
      // 'http://localhost:4000/trade/report',
      // 'http://192.168.1.58:4000/trade/report',
      data: jsonEncode(data),
    );
    // print(response);
    final List<DbReportModel> reportList = (response.data as List).map((e) => DbReportModel.fromJson(e)).toList();

    await createExcelFile(reportList);
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
