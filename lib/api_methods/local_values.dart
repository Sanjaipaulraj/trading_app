import 'package:dio/dio.dart';

import '../models/models.dart';
import 'contants.dart';

Future<LocalValuesModel> getLocalValues() async {
  final dio = Dio();

  final response = await dio.post('$url/get-local');
  return LocalValuesModel.fromJson(response.data);
}

Future<void> setLocalValues(LocalValuesModel data) async {
  final dio = Dio();
  print(data.toJson());

  final _ = await dio.post(
    '$url/set-local',
    data: data.toJson(),
    options: Options(
      headers: {
        'Content-Type': 'application/json', // 🔥 REQUIRED
      },
    ),
  );
}
