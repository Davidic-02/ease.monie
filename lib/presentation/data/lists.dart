import 'package:esae_monie/models/schedule_payments.dart';
import 'package:flutter/material.dart';

final colors = [Colors.blue[200], Colors.green[200], Colors.orange[200]];
final icons = [
  'assets/svgs/moneyTransfer.svg',
  'assets/svgs/paybill.svg',
  'assets/svgs/bankTobank.svg',
];
final labels = ["Money Transfer", "Pay Bill", "Bank to Bank"];

final icons1 = [
  'assets/svgs/recharge.svg',
  'assets/svgs/charity.svg',
  'assets/svgs/loans.svg',
  'assets/svgs/gift.svg',
  'assets/svgs/insurance.svg',
];
final labels1 = ["Recharge", "Charity", "Loan", "Gift", "Insurance"];

final List<ScheduledPayment> scheduledPayments = [
  ScheduledPayment(
    // image: 'assets/netflix.png',
    image: 'assets/images/netflix.png',
    name: 'Netflix',
    amount: '\$15.99',
    dueDate: 'Due in 3 days',
  ),
  ScheduledPayment(
    image: 'assets/images/paypal.png',
    name: 'PayPal',
    amount: '\$25.00',
    dueDate: 'Due tomorrow',
  ),
  ScheduledPayment(
    image: 'assets/images/spotify.png',
    name: 'Spotify',
    amount: '\$9.99',
    dueDate: 'Due in 1 week',
  ),
];
