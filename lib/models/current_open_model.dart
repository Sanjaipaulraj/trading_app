import 'package:json_annotation/json_annotation.dart';

part 'current_open_model.g.dart';

@JsonSerializable()
class CurrentOpenModel {
  String symbol;
  bool reversalPlus;
  bool signalExit;
  bool tcChange;

  CurrentOpenModel({
    required this.symbol,
    required this.reversalPlus,
    required this.signalExit,
    required this.tcChange,
  });

  factory CurrentOpenModel.fromJson(Map<String, dynamic> json) => _$CurrentOpenModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentOpenModelToJson(this);

  @override
  String toString() {
    return "CurrentOpenModel{Symbol : $symbol,Reversal Plus: $reversalPlus,Signal Exit: $signalExit,Tc Change: $tcChange}";
  }
}
