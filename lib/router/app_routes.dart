//import 'package:esae_monie/presentation/screens/onboarding/forgot_password.dart';
import 'package:esae_monie/presentation/screens/home/cards.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/money_transfer.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/payment_managements/amounts.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/payment_managements/confirmation.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/payment_managements/transaction_successful.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/pay_bill/pay_bill.dart';

import 'package:esae_monie/presentation/screens/home/services/charity/charity.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_amount.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_confirmation.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_transaction_success.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/gift.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/type_of_gift.dart';
import 'package:esae_monie/presentation/screens/onboarding/onboarding.dart';
import 'package:esae_monie/presentation/screens/auth/sign_in.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_up.dart';
import 'package:esae_monie/presentation/screens/onboarding/splash_screen.dart';

import 'package:esae_monie/presentation/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:esae_monie/presentation/screens/auth/forgot_password.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/donation.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get routes => {
    SplashScreen.routeName: (context) => const SplashScreen(),
    Onboarding.routeName: (context) => const Onboarding(),
    SignUpScreen.routeName: (context) => const SignUpScreen(),
    ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
    Login.routeName: (context) => const Login(),
    MainScreen.routeName: (_) => const MainScreen(),
    Cards.routeName: (context) => Cards(),
    PayBill.routeName: (context) => PayBill(),
    MoneyTransfer.routeName: (context) => MoneyTransfer(),
    Amount.routeName: (context) => Amount(),
    Confirmation.routeName: (context) => Confirmation(),
    TransactionSuccessful.routeName: (context) => TransactionSuccessful(),
    Charity.routeName: (context) => Charity(),
    Donation.routeName: (context) => Donation(),
    CharityAmount.routeName: (context) => CharityAmount(),
    CharityConfirmation.routeName: (context) => CharityConfirmation(),
    CharityTransactionSuccess.routeName: (context) =>
        CharityTransactionSuccess(),
    Gift.routeName: (context) => Gift(),
    TypeOfGift.routeName: (context) => TypeOfGift(),
  };
}
