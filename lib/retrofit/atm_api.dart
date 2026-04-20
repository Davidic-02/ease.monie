import 'package:esae_monie/models/maps/atm.dart';
import 'package:esae_monie/models/maps/atm_response.dart';
import 'package:esae_monie/models/maps/direction_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'atm_api.g.dart';

@RestApi()
abstract class ATMApi {
  factory ATMApi(Dio dio, {String? baseUrl}) = _ATMApi;

  @GET("place/nearbysearch/json")
  Future<ATMResponse> getNearbyATMs(
    @Query("location") String location, // "lat,lng"
    @Query("radius") int radius,
    @Query("type") String type, // "atm"
  );

  @GET("place/textsearch/json")
  Future<ATMResponse> searchATMs(
    @Query("query") String searchQuery,
    @Query("location") String location,
    @Query("radius") int radius,
    @Query("type") String type,
  );

  @GET("place/details/json")
  Future<ATM> getATMById(
    @Query("place_id") String placeId,
    @Query("key") String apiKey,
  );

  @GET("directions/json")
  Future<DirectionsResponse> getDirections(
    @Query("origin") String origin,
    @Query("destination") String destination,
    @Query("mode") String mode,
  );
}
