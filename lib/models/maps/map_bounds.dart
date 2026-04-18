import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_bounds.g.dart';

@JsonSerializable()
class MapBoundsRequest {
  @JsonKey(name: 'northeast_lat')
  final double northEastLat;
  @JsonKey(name: 'northeast_lng')
  final double northEastLng;
  @JsonKey(name: 'southwest_lat')
  final double southWestLat;
  @JsonKey(name: 'southwest_lng')
  final double southWestLng;
  MapBoundsRequest({
    required this.northEastLat,
    required this.northEastLng,
    required this.southWestLat,
    required this.southWestLng,
  });

  factory MapBoundsRequest.fromLatLngBounds(LatLngBounds bounds) {
    return MapBoundsRequest(
      northEastLat: bounds.northeast.latitude,
      northEastLng: bounds.northeast.longitude,
      southWestLat: bounds.southwest.latitude,
      southWestLng: bounds.southwest.longitude,
    );
  }

  factory MapBoundsRequest.fromJson(Map<String, dynamic> json) =>
      _$MapBoundsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MapBoundsRequestToJson(this);
}
