import 'package:json_annotation/json_annotation.dart';
part 'resolve_account_request.g.dart';

@JsonSerializable()
class ResolveAccountRequest {
  final String account_number;
  final String account_bank;

  ResolveAccountRequest({
    required this.account_number,
    required this.account_bank,
  });

  factory ResolveAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$ResolveAccountRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResolveAccountRequestToJson(this);
}
