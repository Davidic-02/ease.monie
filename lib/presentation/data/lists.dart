import 'package:esae_monie/blocs/paybill/paybill_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/models/schedule_payments.dart';
import 'package:esae_monie/presentation/screens/quick_actions/pay_bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final colors = [
  AppColors.accentNeon.withValues(alpha: 0.4),
  AppColors.blueColor.withValues(alpha: 0.4),
  AppColors.greyColor.withValues(alpha: 0.4),
];
final icons = [
  'assets/svgs/dollar.svg',
  'assets/svgs/bill.svg',
  'assets/svgs/bank.svg',
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
final providers = [
  "Ikeja Electric",
  "Eko Electric",
  "Abuja Disco",
  "Kano Disco",
  "Port Harcourt Disco",
];

final List<Widget> quickActionScreens = [
  BlocProvider(create: (context) => PayBillBloc(), child: const PayBill()),
  BlocProvider(create: (context) => PayBillBloc(), child: const PayBill()),
  BlocProvider(create: (context) => PayBillBloc(), child: const PayBill()),
];
