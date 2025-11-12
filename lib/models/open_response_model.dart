import 'package:json_annotation/json_annotation.dart';

part 'open_response_model.g.dart';

@JsonSerializable()
class OpenPositionModel {
  String actionType;
  String symbol;
  num volume;
  num? takeProfit;

  OpenPositionModel({required this.actionType, required this.symbol, required this.volume, this.takeProfit});

  factory OpenPositionModel.fromJson(Map<String, dynamic> json) => _$OpenPositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenPositionModelToJson(this);
}
