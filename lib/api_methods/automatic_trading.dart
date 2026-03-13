import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'contants.dart';

Future<void> automaticTrading(BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  final value = Provider.of<CheckedBoxProvider>(context, listen: false).isM3Checked;
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
      "$url/automatic/$value",
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
