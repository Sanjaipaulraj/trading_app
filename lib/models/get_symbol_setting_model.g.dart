// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_symbol_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSymbolSettingModel _$GetSymbolSettingModelFromJson(
  Map<String, dynamic> json,
) => GetSymbolSettingModel(
  symbol: json['symbol'] as String,
  section: json['section'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$GetSymbolSettingModelToJson(
  GetSymbolSettingModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'symbol': instance.symbol,
  'section': instance.section,
};
