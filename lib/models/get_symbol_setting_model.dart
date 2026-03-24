import 'package:json_annotation/json_annotation.dart';

part 'get_symbol_setting_model.g.dart';

@JsonSerializable()
class GetSymbolSettingModel {
  String userId;
  String symbol;
  String section;

  GetSymbolSettingModel({required this.symbol, required this.section,required this.userId});

  factory GetSymbolSettingModel.fromJson(Map<String, dynamic> json) => _$GetSymbolSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetSymbolSettingModelToJson(this);

  @override
  String toString() {
    return "GetSymbolSettingModel{Symbol : $symbol,Section: $section,UserId: $userId}";
  }
}
