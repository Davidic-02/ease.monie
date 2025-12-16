import 'package:esae_monie/models/bank_response.dart';
import 'package:esae_monie/models/resolve_account_request.dart';
import 'package:esae_monie/models/resolve_account_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'bank_api.g.dart';

@RestApi()
abstract class BankApi {
  factory BankApi(Dio dio, {String? baseUrl}) = _BankApi;

  @GET("banks/NG")
  Future<BankResponse> getBanks();

  @POST("accounts/resolve")
  Future<ResolveAccountResponse> resolveAccount(
    @Body() ResolveAccountRequest request,
  );
}
