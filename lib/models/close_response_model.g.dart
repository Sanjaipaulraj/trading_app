// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosePositionModel _$ClosePositionModelFromJson(Map<String, dynamic> json) =>
    ClosePositionModel(
      actionType: json['actionType'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$ClosePositionModelToJson(ClosePositionModel instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'symbol': instance.symbol,
    };
