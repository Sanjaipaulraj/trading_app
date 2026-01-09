// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../models/models.dart';

Future<List<TradeHistoryModel>> fetchTradeHistory() async {
  Dio dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 120), receiveTimeout: const Duration(seconds: 120)),
  );

  try {
    final response = await dio.get(
      'http://13.201.225.85/trade/history',
      // 'http://localhost:4000/trade/history',
    );

    final List<TradeHistoryModel> models = (response.data as List).map((e) => TradeHistoryModel.fromJson(e)).toList();

    return models;
  } on DioException catch (e) {
    //  Handle Dio-specific timeout cases
    final statusCode = e.response?.statusCode;
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
    } else if (statusCode == 500) {
      toastification.show(
        backgroundColor: const Color.fromRGBO(199, 226, 201, 1),
        title: const Text('Server Error!'),
        description: Text('Response : ${e.response?.data}'),
        type: ToastificationType.error,
        alignment: Alignment.center,
        autoCloseDuration: const Duration(seconds: 1),
      );
      return [];
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
