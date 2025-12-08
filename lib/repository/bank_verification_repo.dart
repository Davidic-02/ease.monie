import 'package:dio/dio.dart';
import 'package:esae_monie/models/bank_response.dart';
import 'package:esae_monie/models/resolve_account_request.dart';
import 'package:esae_monie/models/resolve_account_response.dart';
import 'package:esae_monie/retrofit/bank_api.dart';

class BankVerificationRepo {
  final BankApi api;

  BankVerificationRepo({required String secretKey})
    : api = BankApi(
        Dio(
          BaseOptions(
            headers: {
              "Authorization": "Bearer $secretKey",
              "Content-Type": "application/json",
            },
          ),
        ),
      );

  Future<BankResponse> getBanks() {
    return api.getBanks();
  }

  Future<ResolveAccountResponse> resolveAccount(ResolveAccountRequest req) {
    return api.resolveAccount(req);
  }
}
