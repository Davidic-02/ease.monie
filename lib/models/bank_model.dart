import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class Bank {
  final String name;
  final String code;

  Bank({required this.name, required this.code});

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);
  Map<String, dynamic> toJson() => _$BankToJson(this);
}
