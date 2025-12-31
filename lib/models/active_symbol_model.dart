import 'package:json_annotation/json_annotation.dart';

part 'active_symbol_model.g.dart';

@JsonSerializable()
class ActiveSymbolModel {
  String symbol;
  num profit;

  ActiveSymbolModel({required this.symbol, required this.profit});

  factory ActiveSymbolModel.fromJson(Map<String, dynamic> json) => _$ActiveSymbolModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveSymbolModelToJson(this);

  @override
  String toString() {
    return "ActiveSymbolModel{Symbol : $symbol,Profit: $profit}";
  }
}
