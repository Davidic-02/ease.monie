import 'package:esae_monie/models/bank_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bank_response.g.dart';

@JsonSerializable()
class BankResponse {
  final String status;
  final List<Bank> data;

  BankResponse({required this.status, required this.data});

  factory BankResponse.fromJson(Map<String, dynamic> json) =>
      _$BankResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankResponseToJson(this);
}
