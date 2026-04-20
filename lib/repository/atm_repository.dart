import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/models/maps/direction_response.dart';
import 'package:esae_monie/retrofit/atm_api.dart';
import 'package:esae_monie/services/logging_helper.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AtmRepository {
  final ATMApi _atmApi;

  AtmRepository(this._atmApi);

  Future<List<ATM>> getNearbyATMs({
    required double latitude,
    required double longitude,
    int radiusInMeters = 5000,
    int limit = 50,
  }) async {
    try {
      logInfo(
        'Fetching nearby ATMs: lat=$latitude, lng=$longitude, radius=$radiusInMeters',
      );

      final response = await _atmApi.getNearbyATMs(
        '$latitude,$longitude',
        radiusInMeters,
        'atm',
      );

      if (!response.isSuccess) {
        throw Exception('Failed to fetch nearby ATMs');
      }

      logInfo('Successfully fetched ${response.data.length} nearby ATMs');
      return response.data;
    } catch (e) {
      logError('Error fetching nearby ATMs: $e', StackTrace.current);
      rethrow;
    }
  }

  Future<List<ATM>> searchATMs({
    required String query,
    required double latitude,
    required double longitude,
    int limit = 50,
  }) async {
    try {
      logInfo('Searching ATMs with query: $query');
      final response = await _atmApi.searchATMs(
        '$query ATM',
        '$latitude,$longitude',
        5000,
        'atm',
      );
      if (!response.isSuccess) {
        throw Exception('Failed to fetch nearby ATMs');
      }
      return response.data;
    } catch (e) {
      logError('Error searching ATMs: $e', StackTrace.current);
      rethrow;
    }
  }

  List<ATM> filterATMsInBounds({
    required List<ATM> allATMs,
    required LatLngBounds bounds,
  }) {
    return allATMs.where((atm) {
      return bounds.contains(LatLng(atm.latitude, atm.longitude));
    }).toList();
  }

  Future<DirectionsResponse> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    try {
      final response = await _atmApi.getDirections(
        '$originLat,$originLng',
        '$destLat,$destLng',
        'driving',
      );
      if (response.status != 'OK') {
        throw Exception('Directions API failed: ${response.status}');
      }

      if (response.routes.isEmpty) {
        throw Exception('No route returned from Google API');
      }

      return response;
    } catch (e) {
      logError('Error fetching route: $e', StackTrace.current);
      rethrow;
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    final int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      final int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      final int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
