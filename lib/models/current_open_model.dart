import 'package:json_annotation/json_annotation.dart';

part 'current_open_model.g.dart';

@JsonSerializable()
class CurrentOpenModel {
  String symbol;
  String method;
  String actionType;
  bool reversalPlus;
  bool reversal;
  bool signalExit;
  bool tcChange;
  bool hyperWave;
  bool moneyFlow;

  CurrentOpenModel({
    required this.symbol,
    required this.method,
    required this.actionType,
    required this.reversalPlus,
    required this.reversal,
    required this.signalExit,
    required this.tcChange,
    required this.hyperWave,
    required this.moneyFlow,
  });

  factory CurrentOpenModel.fromJson(Map<String, dynamic> json) => _$CurrentOpenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentOpenModelToJson(this);

  @override
  String toString() {
    return "CurrentOpenModel{Symbol : $symbol,Method : $method,Action Type : $actionType, Reversal Plus: $reversalPlus,Reversal: $reversal,Signal Exit: $signalExit,Tc Change: $tcChange,Hyper Wave: $hyperWave,Money Flow: $moneyFlow}";
  }
}
