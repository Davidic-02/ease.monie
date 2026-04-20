import 'package:esae_monie/models/maps/atm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'atm_response.g.dart';

@JsonSerializable()
class ATMResponse {
  final String status;

  @JsonKey(name: "results")
  final List<ATM> data;

  final String? nextPageToken;

  ATMResponse({required this.status, required this.data, this.nextPageToken});

  factory ATMResponse.fromJson(Map<String, dynamic> json) =>
      _$ATMResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ATMResponseToJson(this);

  bool get isSuccess => status == 'OK';
}
