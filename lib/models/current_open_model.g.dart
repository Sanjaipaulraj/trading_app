// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_open_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentOpenModel _$CurrentOpenModelFromJson(Map<String, dynamic> json) =>
    CurrentOpenModel(
      symbol: json['symbol'] as String,
      reversalPlus: json['reversalPlus'] as bool,
      signalExit: json['signalExit'] as bool,
      tcChange: json['tcChange'] as bool,
    );

Map<String, dynamic> _$CurrentOpenModelToJson(CurrentOpenModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'reversalPlus': instance.reversalPlus,
      'signalExit': instance.signalExit,
      'tcChange': instance.tcChange,
    };
