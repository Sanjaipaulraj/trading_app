import 'package:auditplus_fx/models/get_symbol_setting_model.dart';
import 'package:dio/dio.dart';
import 'contants.dart';

Future<Map<String, bool>> getSymbolSetting({
  required String userId,
  required String symbol,
  required String section,
}) async {
  final dio = Dio();

  final data = GetSymbolSettingModel(userId: userId, symbol: symbol, section: section);
  final response = await dio.post('$url/get-symbol', data: data.toJson());
  return Map<String, bool>.from(response.data);
}
