import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart'; // This file will be generated

@JsonSerializable()
class ResponseModel {
  String? name;
  String? status;

  ResponseModel({required this.name, required this.status});

  // Factory constructor for deserialization (from JSON)
  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);

  // Method for serialization (to JSON)
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
