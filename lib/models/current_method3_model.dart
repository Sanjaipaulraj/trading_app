import 'package:json_annotation/json_annotation.dart';

part 'current_method3_model.g.dart';

@JsonSerializable()
class CurrentMethod3Model {
  String symbol;
  num volume;
  bool m3Checked;

  CurrentMethod3Model({required this.symbol, required this.volume, required this.m3Checked});

  factory CurrentMethod3Model.fromJson(Map<String, dynamic> json) => _$CurrentMethod3ModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentMethod3ModelToJson(this);

  @override
  String toString() {
    return "CurrentMethod3Model{Symbol : $symbol,Volume : $volume,M3Checked: $m3Checked}";
  }
}
