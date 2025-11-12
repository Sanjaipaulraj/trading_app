import 'package:json_annotation/json_annotation.dart';

part 'close_response_model.g.dart';

@JsonSerializable()
class ClosePositionModel {
  String actionType;
  String symbol;

  ClosePositionModel({required this.actionType, required this.symbol});

  factory ClosePositionModel.fromJson(Map<String, dynamic> json) => _$ClosePositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClosePositionModelToJson(this);
}
