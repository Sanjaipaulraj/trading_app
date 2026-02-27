import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_app/Providers/value_provider.dart';

Future<void> liveUpdation(BuildContext context) async {
  final valProv = Provider.of<ValueProvider>(context, listen: false);
  String? symbol = valProv.selectedValue;
  if (symbol == null) {
    return;
  }
  Dio dio = Dio();
  try {
    final _ = await dio.post(
      // 'http://13.201.225.85/trade/live_status',
      'http://localhost:4000/trade/live_status',
      data: symbol,
    );
  } on DioException catch (e) {
    final statusCode = e.response?.statusCode;
    if (statusCode == 409) {
      valProv.clearCurrentOpenBySymbol(symbol);
    }
  }
}
