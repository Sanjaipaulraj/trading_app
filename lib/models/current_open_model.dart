import 'package:json_annotation/json_annotation.dart';

part 'current_open_model.g.dart';

@JsonSerializable()
class CurrentOpenModel {
  String symbol;
  String method;
  bool reversalPlus;
  bool reversal;
  bool signalExit;
  bool tcChange;

  CurrentOpenModel({
    required this.symbol,
    required this.method,
    required this.reversalPlus,
    required this.reversal,
    required this.signalExit,
    required this.tcChange,
  });

  factory CurrentOpenModel.fromJson(Map<String, dynamic> json) => _$CurrentOpenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentOpenModelToJson(this);

  @override
  String toString() {
    return "CurrentOpenModel{Symbol : $symbol,Method : $method,Reversal Plus: $reversalPlus,Reversal: $reversal,Signal Exit: $signalExit,Tc Change: $tcChange}";
  }
}
