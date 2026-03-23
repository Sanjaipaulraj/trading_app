
import 'package:auditplus_fx/api_methods/contants.dart';
import 'package:dio/dio.dart';

Future<void> symbolSetting({
  required String symbol,
  required String section,
  required Map<String, bool> checkedValues,
}) async {
  final dio = Dio();

  final data = {
    "symbol": symbol,
    "section": section,
    "checkedValues": checkedValues,
  };
  final response = await dio.post(
    '$url/symbol-setting',
    data: data,
    options: Options(headers: {'Content-Type': 'application/json'}),
  );
  print(response.data);
}