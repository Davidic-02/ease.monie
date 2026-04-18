import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/models/maps/map_bounds.dart';
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
        latitude,
        longitude,
        radiusInMeters,
        limit,
      );

      if (!response.isSuccess) {
        throw Exception(response.message ?? 'Failed to fetch nearby ATMs');
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
        query,
        latitude,
        longitude,
        limit,
      );

      if (!response.isSuccess) {
        throw Exception(response.message ?? 'Search failed');
      }
      logInfo('Search returned ${response.data.length} results');
      return response.data;
    } catch (e) {
      logError('Error searching ATMs: $e', StackTrace.current);
      rethrow;
    }
  }

  Future<List<ATM>> getATMsInBounds({
    required LatLngBounds bounds,
    int limit = 50,
  }) async {
    try {
      logInfo(
        'Fetching ATMs in bounds: NE(${bounds.northeast.latitude}, ${bounds.northeast.longitude}), SW(${bounds.southwest.latitude}, ${bounds.southwest.longitude})',
      );
      final request = MapBoundsRequest.fromLatLngBounds(bounds);
      final response = await _atmApi.getATMsInBounds(request, limit);
      if (!response.isSuccess) {
        throw Exception(response.message ?? 'Failed to fetch ATMs in bounds');
      }

      logInfo('Successfully fetched ${response.data.length} ATMs in bounds');
      return response.data;
    } catch (e) {
      logError('Error fetching ATMs in bounds: $e', StackTrace.current);
      rethrow;
    }
  }

  Future<ATM> getAtMById(String atmId) async {
    try {
      logInfo('Fetching ATM details for ID: $atmId');
      final atm = await _atmApi.getATMById(atmId);
      logInfo('Successfully fetched ATM: ${atm.name}');
      return atm;
    } catch (e) {
      logError('Error fetching ATM by ID: $e', StackTrace.current);
      rethrow;
    }
  }

  Future<ATM> getATMDetails(String atmId) async {
    try {
      logInfo('Fetching detailed ATM info for ID: $atmId');
      final atm = await _atmApi.getATMDetails(atmId);
      logInfo('Successfully fetched ATM details: ${atm.name}');
      return atm;
    } catch (e) {
      logError('Error fetching ATM details: $e', StackTrace.current);
      rethrow;
    }
  }
}
