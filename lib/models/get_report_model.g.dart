// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReportModel _$GetReportModelFromJson(Map<String, dynamic> json) =>
    GetReportModel(
      symbol: json['symbol'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$GetReportModelToJson(GetReportModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
