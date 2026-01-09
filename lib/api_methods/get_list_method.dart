// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:trading_app/Providers/token_provider.dart';

Future<List<String>> getList(BuildContext context) async {
  final token = Provider.of<MytokenProvider>(context, listen: false).token;
  Dio dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 120), receiveTimeout: const Duration(seconds: 120)),
  );

  try {
    final response = await dio.get(
      'http://13.201.225.85/trade/list',
      // 'http://localhost:4000/trade/list',
      options: Options(headers: {'Content-Type': 'application/json', 'auth-token': token}),
    );
    if (response.statusCode == 200) {
      final List<String> data = (response.data as List).map((e) => e.toString()).toList();
      final parsedList = data.toList();

      return parsedList;
    } else if (response.statusCode == 500) {
      toastification.show(
        backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
        title: const Text('Server Error!'),
        description: Text('Response : ${response.data}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 1),
      );
      return [];
    } else {
      Provider.of<MytokenProvider>(context, listen: false).clearToken();
      toastification.show(
        backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Status code: ${response.statusCode}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 1),
      );
      return [];
    }
  } on DioException catch (e) {
    //  Handle Dio-specific timeout cases
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      toastification.show(
        backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Timeout!'),
        description: const Text('Request timed out. Please try again later.'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: Duration(seconds: 2),
      );
    } else {
      Provider.of<MytokenProvider>(context, listen: false).clearToken();
      toastification.show(
        backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
        title: const Text('Error!'),
        description: Text('Error: ${e.message}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: Duration(seconds: 2),
      );
    }
    return [];
  } catch (e) {
    //  Catch unexpected errors
    toastification.show(
      backgroundColor: const Color.fromRGBO(242, 186, 185, 1),
      title: const Text('Error!'),
      description: Text('Unexpected error: $e'),
      type: ToastificationType.error,
      alignment: Alignment.center,
      autoCloseDuration: const Duration(seconds: 2),
    );
    return [];
  }
}
