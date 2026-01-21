// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_open_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentOpenModel _$CurrentOpenModelFromJson(Map<String, dynamic> json) =>
    CurrentOpenModel(
      symbol: json['symbol'] as String,
      method: json['method'] as String,
      reversalPlus: json['reversalPlus'] as bool,
      reversal: json['reversal'] as bool,
      signalExit: json['signalExit'] as bool,
      tcChange: json['tcChange'] as bool,
    );

Map<String, dynamic> _$CurrentOpenModelToJson(CurrentOpenModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'method': instance.method,
      'reversalPlus': instance.reversalPlus,
      'reversal': instance.reversal,
      'signalExit': instance.signalExit,
      'tcChange': instance.tcChange,
    };
