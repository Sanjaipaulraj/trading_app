// import 'dart:convert';

import 'package:auditplus_fx/models/current_automation_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'contants.dart';

Future<void> automaticTrading(BuildContext context, CurrentAutomationModel data) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // final encoded = jsonEncode(data.toJson());
  // await prefs.setString('AutomateCurrentOpening', encoded);

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
  try {
    final _ = dio.post(
      "$url/automatic",
      data: data,
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );
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
