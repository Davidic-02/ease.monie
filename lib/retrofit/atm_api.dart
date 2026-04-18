import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/models/maps/atm_response.dart';
import 'package:esae_monie/models/maps/map_bounds.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'atm_api.g.dart';

@RestApi()
abstract class ATMApi {
  factory ATMApi(Dio dio, {String? baseUrl}) = _ATMApi;

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

  @POST("atms/bounds")
  Future<ATMResponse> getATMsInBounds(
    @Body() MapBoundsRequest request,
    @Query("limit") int limit,
  );

  @GET("atms/{id}")
  Future<ATM> getATMById(@Path("id") String atmId);

  @GET("atms/{id}/details")
  Future<ATM> getATMDetails(@Path("id") String atmId);
}
