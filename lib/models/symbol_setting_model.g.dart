// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolSettingModel _$SymbolSettingModelFromJson(Map<String, dynamic> json) =>
    SymbolSettingModel(
      symbol: json['symbol'] as String,
      section: json['section'] as String,
      checkedValues: json['checkedValues'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SymbolSettingModelToJson(SymbolSettingModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'section': instance.section,
      'checkedValues': instance.checkedValues,
    };
