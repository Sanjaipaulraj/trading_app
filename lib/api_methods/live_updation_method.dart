import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auditplus_fx/Providers/providers.dart';

import 'contants.dart';

Future<void> liveUpdation(BuildContext context) async {
  final valProv = Provider.of<ValueProvider>(context, listen: false);
  String? symbol = valProv.selectedValue;
  if (symbol == null) {
    return;
  }
  Dio dio = Dio();
  try {
    final _ = await dio.post('$url/live_status/$symbol');
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;
    if (statusCode == 409) {
      valProv.clearCurrentOpenBySymbol(symbol);
    }
  }
}
