// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import '../models/models.dart';
import 'contants.dart';

Future<void> onClosePosition(BuildContext context, String actionType) async {
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
  // final symbol = Provider.of<ValueProvider>(context, listen: false).selectedValue;
  final symbol = Provider.of<ValueProvider>(context, listen: false).manualSelectedValue;
  String description = "Manual Close";
  final data = CloseRequestModel(actionType: actionType, symbol: symbol, description: description);
  try {
    await dio.post(
      '$url/close',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
      data: jsonEncode(data),
    );
    Provider.of<ValueProvider>(context, listen: false).clearCurrentOpenBySymbol(symbol!);
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 409) {
      toastification.show(
        backgroundColor: Color.fromRGBO(199, 226, 201, 1),
        title: const Text('INFO!'),
        description: Text('${e.response?.data}'),
        type: ToastificationType.warning,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else if (statusCode == 400) {
      toastification.show(
        backgroundColor: Color.fromRGBO(199, 226, 201, 1),
        title: const Text('Error!'),
        description: Text('${e.response?.data}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else if (statusCode == 401) {
      toastification.show(
        backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
        title: Text('${e.response?.data}'),
        description: const Text('Token not Valid'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.show(
        backgroundColor: Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Status code : $statusCode'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  } catch (e) {
    toastification.show(
      backgroundColor: Color.fromRGBO(242, 186, 185, 1),
      title: const Text('Error!'),
      description: Text('Error occurs : $e'),
      type: ToastificationType.error,
      alignment: Alignment.center,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}
