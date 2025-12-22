import 'package:json_annotation/json_annotation.dart';

part 'close_request_model.g.dart';

@JsonSerializable()
class CloseRequestModel {
  String actionType;
  String? symbol;
  String description;

  CloseRequestModel({required this.actionType, required this.symbol, required this.description});

  factory CloseRequestModel.fromJson(Map<String, dynamic> json) => _$CloseRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloseRequestModelToJson(this);

  @override
  String toString() {
    return "CloseRequestModel{Action type: $actionType,Position Id: $symbol,Description : $description}";
  }
}
