import 'package:json_annotation/json_annotation.dart';

part 'nearby_atms_request.g.dart';

@JsonSerializable()
class NearbyATMsRequest {
  final double latitude;
  final double longitude;
  @JsonKey(defaultValue: 5000)
  final int radiusInMeters;
  final int? limit;

  NearbyATMsRequest({
    required this.latitude,
    required this.longitude,
    this.radiusInMeters = 5000,
    this.limit = 50,
  });

  factory NearbyATMsRequest.fromJson(Map<String, dynamic> json) =>
      _$NearbyATMsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyATMsRequestToJson(this);
}
