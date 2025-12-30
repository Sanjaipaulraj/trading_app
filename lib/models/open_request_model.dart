import 'package:json_annotation/json_annotation.dart';

part 'open_request_model.g.dart';

@JsonSerializable()
class OpenRequestModel {
  String actionType;
  String? symbol;
  num volume;
  num? takeProfit;
  bool reversalPlus;
  bool reversal;
  bool signalExit;
  bool tcChange;

  OpenRequestModel({
    required this.actionType,
    required this.symbol,
    required this.volume,
    this.takeProfit,
    required this.reversalPlus,
    required this.reversal,
    required this.signalExit,
    required this.tcChange,
  });

  factory OpenRequestModel.fromJson(Map<String, dynamic> json) => _$OpenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenRequestModelToJson(this);

  @override
  String toString() {
    return "OpenRequestModel{Action type: $actionType,Symbol : $symbol,Volume: $volume,Take profit: $takeProfit,Reversal Plus: $reversalPlus,Reversal: $reversal,Signal Exit: $signalExit,Tc Change: $tcChange}";
  }
}
