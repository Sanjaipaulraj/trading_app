import 'package:json_annotation/json_annotation.dart';
part 'current_automation_model.g.dart';

@JsonEnum()
enum ActionType { add, disable, update, close }

@JsonSerializable()
class CurrentAutomationModel {
  String method;
  String symbol;
  num volume;
  ActionType action; // ✅ FIXED

  CurrentAutomationModel({required this.method, required this.symbol, required this.volume, required this.action});

  factory CurrentAutomationModel.fromJson(Map<String, dynamic> json) => _$CurrentAutomationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentAutomationModelToJson(this);

  @override
  String toString() {
    return "CurrentAutomationModel{Method : $method, Symbol : $symbol, Volume : $volume, Action: $action}";
  }
}
