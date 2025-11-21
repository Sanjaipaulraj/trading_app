// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseRequestModel _$CloseRequestModelFromJson(Map<String, dynamic> json) =>
    CloseRequestModel(
      actionType: json['actionType'] as String,
      positionId: json['positionId'] as String?,
    );

Map<String, dynamic> _$CloseRequestModelToJson(CloseRequestModel instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'positionId': instance.positionId,
    };
