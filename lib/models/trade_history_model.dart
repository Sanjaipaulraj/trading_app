import 'package:json_annotation/json_annotation.dart';

part 'trade_history_model.g.dart';

@JsonSerializable()
class TradeHistoryModel {
  String symbol;
  num profit;

  TradeHistoryModel({required this.symbol, required this.profit});

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) => _$TradeHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradeHistoryModelToJson(this);

  @override
  String toString() {
    return "TradeHistoryModel{Symbol : $symbol,Profit: $profit}";
  }
}
