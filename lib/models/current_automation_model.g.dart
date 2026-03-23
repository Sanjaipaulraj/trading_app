// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_automation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentAutomationModel _$CurrentAutomationModelFromJson(
  Map<String, dynamic> json,
) => CurrentAutomationModel(
  method: json['method'] as String,
  symbol: json['symbol'] as String,
  volume: json['volume'] as num,
  isEnabled: json['isEnabled'] as bool,
  action: json['action'] as String,
);

Map<String, dynamic> _$CurrentAutomationModelToJson(
  CurrentAutomationModel instance,
) => <String, dynamic>{
  'method': instance.method,
  'symbol': instance.symbol,
  'volume': instance.volume,
  'isEnabled': instance.isEnabled,
  'action': instance.action,
};
