import 'package:json_annotation/json_annotation.dart';

part 'current_automation_model.g.dart';

@JsonSerializable()
class CurrentAutomationModel {
  String method;
  String symbol;
  num volume;
  // bool isChecked;
  bool isEnabled;
  String action;

  // CurrentAutomationModel({required this.method, required this.symbol, required this.volume, required this.isChecked});
  CurrentAutomationModel({
    required this.method,
    required this.symbol,
    required this.volume,
    required this.isEnabled,
    required this.action,
  });

  factory CurrentAutomationModel.fromJson(Map<String, dynamic> json) => _$CurrentAutomationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentAutomationModelToJson(this);

  @override
  String toString() {
    // return "CurrentAutomationModel{Method : $method,Symbol : $symbol,Volume : $volume,M3Checked: $isChecked}";
    return "CurrentAutomationModel{Method : $method,Symbol : $symbol,Volume : $volume,}";
  }
}
