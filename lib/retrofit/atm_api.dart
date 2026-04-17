import 'package:esae_monie/models/atm.dart';
import 'package:esae_monie/models/atm_response.dart';
import 'package:esae_monie/models/map_bounds.dart';
import 'package:esae_monie/models/maps/atm_response.dart';
import 'package:esae_monie/models/nearby_atms_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'atm_api.g.dart';

@RestApi()
abstract class AtmApi {
  factory AtmApi(Dio dio, {String? baseUrl}) = _ATMApi;

  @GET("atms/nearby")
  Future<ATMResponse> getNearbyATMs(
    @Query("latitude") double latitude,
    @Query("longitude") double longitude,
    @Query("radius") int radiusInMeters,
    @Query("limit") int limit,
  );

  @GET("atms/search")
  Future<ATMResponse> searchATMs(
    @Query("query") String searchQuery,
    @Query("latitude") double latitude,
    @Query("longitude") double longitude,
    @Query("limit") int limit,
  );
}
