import 'package:esae_monie/models/maps/atm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'atm_response.g.dart';

@JsonSerializable()
class ATMResponse {
  final String status;
  final List<ATM> data;
  final String? message;
  @JsonKey(defaultValue: 0)
  final int? count;

  ATMResponse({
    required this.status,
    required this.data,
    this.message,
    this.count,
  });

  factory ATMResponse.fromJson(Map<String, dynamic> json) =>
      _$ATMResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ATMResponseToJson(this);

  bool get isSuccess => status.toLowerCase() == 'success';
}
