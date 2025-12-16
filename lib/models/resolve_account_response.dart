import 'package:json_annotation/json_annotation.dart';
part 'resolve_account_response.g.dart';

@JsonSerializable()
class ResolveAccountResponse {
  final String status;
  final AccountData data;

  ResolveAccountResponse({required this.status, required this.data});

  factory ResolveAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$ResolveAccountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResolveAccountResponseToJson(this);
}

@JsonSerializable()
class AccountData {
  final String account_name;
  final String account_number;

  AccountData({required this.account_name, required this.account_number});

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);
  Map<String, dynamic> toJson() => _$AccountDataToJson(this);
}
