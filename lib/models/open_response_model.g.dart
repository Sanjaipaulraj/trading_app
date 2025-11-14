// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenPositionModel _$OpenPositionModelFromJson(Map<String, dynamic> json) =>
    OpenPositionModel(
      actionType: json['actionType'] as String,
      symbol: json['symbol'] as String?,
      volume: json['volume'] as num,
      takeProfit: json['takeProfit'] as num?,
    );

Map<String, dynamic> _$OpenPositionModelToJson(OpenPositionModel instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'symbol': instance.symbol,
      'volume': instance.volume,
      'takeProfit': instance.takeProfit,
    };
