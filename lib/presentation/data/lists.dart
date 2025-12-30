import 'package:esae_monie/blocs/paybill/paybill_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/models/insurance_model.dart';
import 'package:esae_monie/models/loan_model.dart';
import 'package:esae_monie/models/schedule_payments.dart';
import 'package:esae_monie/models/selected_network.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/money_transfer.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/pay_bill/pay_bill.dart';

import 'package:esae_monie/presentation/screens/home/services/charity/charity.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/gift.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/insurance.dart';
import 'package:esae_monie/presentation/screens/home/services/loan/loan.dart';
import 'package:esae_monie/presentation/screens/home/services/recharge/recharge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final double interestRate = 0.05;

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

final List durations = [
  '6 Month',
  '8 Month',
  '10 Month',
  '12 Month',
  '14 Month',
  '16 Month',
];

final List<Widget> quickActionScreens = [
  MoneyTransfer(),
  BlocProvider(create: (context) => PayBillBloc(), child: const PayBill()),
  BlocProvider(create: (context) => PayBillBloc(), child: const PayBill()),
];

final List servicesScreen = [
  Recharge(),
  Charity(),
  Loan(),
  Gift(),
  Insurance(),
];

final List<InsuranceModel> insuranceModel = [
  InsuranceModel(plan: 'Monthly Plan', time: 'month', amount: '2300.00'),
  InsuranceModel(plan: 'One Time Plan', time: 'year', amount: '2000.00'),
  InsuranceModel(plan: 'Yearly Plan', time: 'year', amount: '3000.00'),
];

final List<LoanModel> loanModel = [
  LoanModel(title: 'Paid', amount: 200000),
  LoanModel(title: 'Due', amount: 150000),
  LoanModel(title: 'Processing', amount: 50000),
];

final List<String> paymentPlans = ['Monthly', 'Quarterly', 'Yearly'];

final List<RecommendedLoan> recommendedLoan = [
  RecommendedLoan(
    title: 'Home Loan',
    image: 'assets/svgs/car_loan.svg',
    amount: 12000.00,
  ),

  RecommendedLoan(
    title: 'Business Loan',
    image: 'assets/svgs/car_loan.svg',
    amount: 12000.00,
  ),
  RecommendedLoan(
    title: 'Education Loan',
    image: 'assets/svgs/car_loan.svg',
    amount: 12000.00,
  ),
  RecommendedLoan(
    title: 'Car Loan',
    image: 'assets/svgs/car_loan.svg',
    amount: 12000.00,
  ),
  RecommendedLoan(
    title: 'Home Loan',
    image: 'assets/svgs/car_loan.svg',
    amount: 12000.00,
  ),
];

final String totalAmount = '8,500';

final List<RecentTransfer> recentTransfer = [
  RecentTransfer(
    image: 'assets/images/profilepicture.png',
    //image: 'assets/svgs/profile_pic1.svg',
    name: 'Dr Kamal',
    amount: '\$15.99',
  ),
  RecentTransfer(
    image: 'assets/images/profilepicture.png',
    // image: 'assets/svgs/profile_pic2.svg',
    name: 'Jonathan',
    amount: '\$15.99',
  ),
  RecentTransfer(
    image: 'assets/images/profilepicture.png',
    //image: 'assets/svgs/profile_pic3.svg',
    name: 'Will Happier',
    amount: '\$15.99',
  ),
  RecentTransfer(
    image: 'assets/images/profilepicture.png',
    // image: 'assets/svgs/profile_pic2.svg',
    name: 'Adekoya david',
    amount: '\$15.99',
  ),
];

final List<SelectedNetwork> selectedNetwork = [
  SelectedNetwork(image: 'assets/images/mtn.png', name: 'MTN'),
  SelectedNetwork(image: 'assets/images/airtel.png', name: 'Airtel'),
  SelectedNetwork(image: 'assets/images/glo.png', name: 'Glo'),
  SelectedNetwork(image: 'assets/images/9mobile.png', name: '9mobile'),
];

final presetAmounts = [
  1000.0,
  2000.0,
  3000.0,
  4000.0,
  5000.0,
  10000.0,
  20000.0,
];
final paymentPlan = ['Monthly', 'Quartly', 'Yearly'];

final charity1 = useState(
  ServicesModel(
    imagePath: 'assets/images/child_education.png',
    title: 'Donate For Child Education',
    organizer: 'Arrange by HEADS Foundation',
    targetAmount: 1000000,
    donatedAmount: 25000,
  ),
);

final charity2 = useState(
  ServicesModel(
    imagePath: 'assets/images/cancer_patient.png',
    title: 'Donate For Cancer Patients',
    organizer: 'Arrange by Care Club',
    targetAmount: 1000000,
    donatedAmount: 15000,
  ),
);

final gift1 = ServicesModel(
  imagePath: 'assets/images/gift1.png',
  title: 'Eid Gift',
  organizer: 'Send Eid Gift to your loved ones',
  targetAmount: 0,
  donatedAmount: 0,
);

final gift2 = ServicesModel(
  imagePath: 'assets/images/gift2.png',
  title: 'Birthday Gift',
  organizer: 'Send Birthday Gift to your loved ones',
  targetAmount: 0,
  donatedAmount: 0,
);

final gift3 = ServicesModel(
  imagePath: 'assets/images/gift3.png',
  title: 'Marriage Gift',
  organizer: 'Send Marriage Gift to your loved ones',
  targetAmount: 0,
  donatedAmount: 0,
);

final eidOfferDeadline = DateTime.now().add(const Duration(days: 3));
final birthdayOfferDeadline = DateTime.now().add(const Duration(days: 10));
final insurance1 = useState(
  ServicesModel(
    imagePath: 'assets/images/insurance1.png',
    title: 'Family Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),
);

final insurance2 = useState(
  ServicesModel(
    imagePath: 'assets/images/insurance2.png',
    title: 'House Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),
);

final insurance3 = useState(
  ServicesModel(
    imagePath: 'assets/images/insurance3.png',
    title: 'Health Insurance',
    organizer: 'Family Plans Cover two or more members',
    targetAmount: 0,
    donatedAmount: 0,
  ),
);

final familyOfferDeadline = DateTime.now().add(const Duration(days: 3));
final houseOfferDeadline = DateTime.now().add(const Duration(days: 10));
