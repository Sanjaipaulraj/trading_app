import 'package:json_annotation/json_annotation.dart';

part 'open_response_model.g.dart';

@JsonSerializable()
class OpenPositionModel {
  String actionType;
  String? symbol;
  num volume;
  num? takeProfit;
  bool reversalPlus;
  bool signalExit;
  bool tcChange;

  OpenPositionModel({
    required this.actionType,
    required this.symbol,
    required this.volume,
    this.takeProfit,
    required this.reversalPlus,
    required this.signalExit,
    required this.tcChange,
  });

  factory OpenPositionModel.fromJson(Map<String, dynamic> json) => _$OpenPositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenPositionModelToJson(this);

  @override
  String toString() {
    return "OpenPositionModel{Action type: $actionType,Symbol : $symbol,Volume: $volume,Take profit: $takeProfit,Reversal Plus: $reversalPlus,Signal Exit: $signalExit,Tc Change: $tcChange}";
  }
}
