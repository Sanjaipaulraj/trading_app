// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_method3_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMethod3Model _$CurrentMethod3ModelFromJson(Map<String, dynamic> json) =>
    CurrentMethod3Model(
      symbol: json['symbol'] as String,
      volume: json['volume'] as num,
      m3Checked: json['m3Checked'] as bool,
    );

Map<String, dynamic> _$CurrentMethod3ModelToJson(
  CurrentMethod3Model instance,
) => <String, dynamic>{
  'symbol': instance.symbol,
  'volume': instance.volume,
  'm3Checked': instance.m3Checked,
};
