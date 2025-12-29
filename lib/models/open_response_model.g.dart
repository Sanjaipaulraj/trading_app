// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenResponseModel _$OpenResponseModelFromJson(Map<String, dynamic> json) =>
    OpenResponseModel(
      stringCode: json['stringCode'] as String,
      numericCode: json['numericCode'] as num,
      message: json['message'] as String,
      orderId: json['orderId'] as String,
      positionId: json['positionId'] as String,
      tradeExecutionTime: json['tradeExecutionTime'] as String,
      tradeStartTime: json['tradeStartTime'] as String,
    );

Map<String, dynamic> _$OpenResponseModelToJson(OpenResponseModel instance) =>
    <String, dynamic>{
      'stringCode': instance.stringCode,
      'numericCode': instance.numericCode,
      'message': instance.message,
      'orderId': instance.orderId,
      'positionId': instance.positionId,
      'tradeExecutionTime': instance.tradeExecutionTime,
      'tradeStartTime': instance.tradeStartTime,
    };
