// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DbReportModel _$DbReportModelFromJson(Map<String, dynamic> json) =>
    DbReportModel(
      openedAt: json['openedAt'] == null
          ? null
          : DateTime.parse(json['openedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      symbol: json['symbol'] as String,
      openPrice: json['openPrice'] as num,
      closePrice: json['closePrice'] as num,
      profit: json['profit'] as num,
      actionType: json['actionType'] as String,
      volume: json['volume'] as num,
      positionId: json['positionId'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$DbReportModelToJson(DbReportModel instance) =>
    <String, dynamic>{
      'openedAt': instance.openedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'symbol': instance.symbol,
      'openPrice': instance.openPrice,
      'closePrice': instance.closePrice,
      'profit': instance.profit,
      'actionType': instance.actionType,
      'volume': instance.volume,
      'positionId': instance.positionId,
      'status': instance.status,
      'description': instance.description,
    };
