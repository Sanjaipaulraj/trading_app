import 'package:auditplus_fx/api_methods/contants.dart';
import 'package:dio/dio.dart';

Future<void> symbolSetting({
  required String userId,
  required String symbol,
  required String section,
  required Map<String, bool> checkedValues,
}) async {
  final dio = Dio();

  final data = {"userId": userId, "symbol": symbol, "section": section, "checkedValues": checkedValues};
  final _ = await dio.post(
    '$url/symbol-setting',
    data: data,
    options: Options(headers: {'Content-Type': 'application/json'}),
  );
}
