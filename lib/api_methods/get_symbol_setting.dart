import 'package:dio/dio.dart';
import 'contants.dart';

Future<Map<String, bool>> getSymbolSetting({
  required String symbol,
  required String section,
}) async {
  final dio = Dio();

  final response = await dio.get(
    '$url/trade/get-symbol/$symbol',
    queryParameters: {"section": section},
  );

  return Map<String, bool>.from(response.data);
}