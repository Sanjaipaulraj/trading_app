import 'dart:convert';

import 'package:auditplus_fx/models/current_method3_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:auditplus_fx/Providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'contants.dart';

Future<void> automaticTrading(BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  final m3Checked = Provider.of<CheckedBoxProvider>(context, listen: false).isM3Checked;
  final valProv = Provider.of<ValueProvider>(context, listen: false);
  final symbol = valProv.m3SelectedValue;
  final volume = valProv.m3Volume;
  //Set a M3Checked in shared preference
  SharedPreferences prefs = await SharedPreferences.getInstance();
  CurrentMethod3Model m3current = CurrentMethod3Model(symbol: symbol!, volume: volume, m3Checked: m3Checked);
  final encoded = jsonEncode(m3current.toJson());
  await prefs.setString('m3CurrentOpening', encoded);

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
      "$url/automatic/$m3Checked",
      data: m3current,
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
