import 'package:json_annotation/json_annotation.dart';

part 'get_report_model.g.dart';

@JsonSerializable()
class GetReportModel {
  String symbol;
  String startDate;
  String endDate;

  GetReportModel({required this.symbol, required this.startDate, required this.endDate});

  factory GetReportModel.fromJson(Map<String, dynamic> json) => _$GetReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetReportModelToJson(this);

  @override
  String toString() {
    return "GetReportModelModel{Symbol : $symbol,Start Date: $startDate,End Date: $endDate}";
  }
}
