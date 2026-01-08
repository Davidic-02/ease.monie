import 'package:esae_monie/models/services_model.dart';

class GiftPayload {
  final ServicesModel service;
  final String name;
  final String accountNumber;
  final String purpose;
  final String password;
  final double amount;
  final String giftMessage;

  GiftPayload({
    required this.service,
    required this.name,
    required this.accountNumber,
    required this.purpose,
    required this.password,
    required this.amount,
    required this.giftMessage,
  });
}
