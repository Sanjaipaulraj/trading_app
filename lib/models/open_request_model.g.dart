// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenRequestModel _$OpenRequestModelFromJson(Map<String, dynamic> json) =>
    OpenRequestModel(
      actionType: json['actionType'] as String,
      symbol: json['symbol'] as String?,
      volume: json['volume'] as num,
      takeProfit: json['takeProfit'] as num?,
      reversalPlus: json['reversalPlus'] as bool,
      signalExit: json['signalExit'] as bool,
      tcChange: json['tcChange'] as bool,
    );

Map<String, dynamic> _$OpenRequestModelToJson(OpenRequestModel instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'symbol': instance.symbol,
      'volume': instance.volume,
      'takeProfit': instance.takeProfit,
      'reversalPlus': instance.reversalPlus,
      'signalExit': instance.signalExit,
      'tcChange': instance.tcChange,
    };
