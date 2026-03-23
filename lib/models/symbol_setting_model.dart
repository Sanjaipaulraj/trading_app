import 'package:json_annotation/json_annotation.dart';

part 'symbol_setting_model.g.dart';

@JsonSerializable()
class SymbolSettingModel {
  String symbol;
  String section;
Map<String,dynamic> checkedValues;

  SymbolSettingModel({required this.symbol, required this.section, required this.checkedValues});

  factory SymbolSettingModel.fromJson(Map<String, dynamic> json) => _$SymbolSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SymbolSettingModelToJson(this);

  @override
  String toString() {
    return "SymbolSettingModelModel{Symbol : $symbol,Start Date: $section,Checked Values: $checkedValues}";
  }
}
