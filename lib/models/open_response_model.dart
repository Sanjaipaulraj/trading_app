import 'package:json_annotation/json_annotation.dart';

part 'open_response_model.g.dart';

@JsonSerializable()
class OpenResponseModel {
  String stringCode;
  num numericCode;
  String message;
  String orderId;
  String positionId;
  String tradeExecutionTime;
  String tradeStartTime;

  OpenResponseModel({
    required this.stringCode,
    required this.numericCode,
    required this.message,
    required this.orderId,
    required this.positionId,
    required this.tradeExecutionTime,
    required this.tradeStartTime,
  });

  factory OpenResponseModel.fromJson(Map<String, dynamic> json) => _$OpenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenResponseModelToJson(this);

  @override
  String toString() {
    return "OpenResponseModel{String code: $stringCode,Numeric Code : $numericCode,Message: $message,Order Id: $orderId,Position Id: $positionId,Trade Execution Time: $tradeExecutionTime,Trade Start Time: $tradeStartTime}";
  }
}
