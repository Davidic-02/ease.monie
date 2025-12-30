import 'package:esae_monie/blocs/loan/loan_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/loan_model.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/loan/loan_payment_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LoanPaymentPlans extends HookWidget {
  static const String routeName = 'LoanPaymentPlans';
  const LoanPaymentPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final loan = ModalRoute.of(context)!.settings.arguments as RecommendedLoan;
    final nameFocus = useFocusNode();
    final cnicFocus = useFocusNode();
    final mobileFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    return Scaffold(
      body: BlocBuilder<LoanBloc, LoanState>(
        buildWhen: (previous, current) =>
            _loanPaymentBuildWhen(context, previous, current),
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Payment Plans',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                loan.image,
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loan.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onBackground,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₦${loan.amount.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.7), // subtle
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        TextTitle(text: 'Duration'),
                        AppSpacing.verticalSpaceSmall,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: durations.map((duration) {
                              final isSelected = state.selectedPlan == duration;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    return context.read<LoanBloc>().add(
                                      LoanEvent.planSelected(duration),
                                    );
                                  },
                                  child: Container(
                                    width: screenWidth * 0.25,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      duration,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.blue
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        TextTitle(text: 'Enter Your Information'),
                        Column(
                          children: [
                            CustomTextFormField(
                              key: const ValueKey("name"),
                              focusNode: nameFocus,
                              hintText: "Name",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                context.read<LoanBloc>().add(
                                  LoanEvent.nameChanged(value),
                                );
                              },

                              errorText:
                                  !state.name.isPure && state.name.isNotValid
                                  ? "Name is Required"
                                  : null,

                              onFieldSubmitted: (_) => cnicFocus.requestFocus(),
                            ),

                            CustomTextFormField(
                              key: const ValueKey("cnic"),
                              focusNode: cnicFocus,
                              hintText: "CNIC",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                context.read<LoanBloc>().add(
                                  LoanEvent.cnicChanged(value),
                                );
                              },

                              errorText:
                                  !state.cnic.isPure && state.cnic.isNotValid
                                  ? "CNIC is Required"
                                  : null,
                              onFieldSubmitted: (_) =>
                                  mobileFocus.requestFocus(),
                            ),

                            CustomTextFormField(
                              key: const ValueKey("mobile"),
                              focusNode: mobileFocus,
                              hintText: "Mobile Number",
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                context.read<LoanBloc>().add(
                                  LoanEvent.mobileChanged(value),
                                );
                              },

                              errorText:
                                  !state.mobile.isPure &&
                                      state.mobile.isNotValid
                                  ? "Mobile Number is Required"
                                  : null,
                              onFieldSubmitted: (_) =>
                                  passwordFocus.requestFocus(),
                            ),

                            CustomTextFormField(
                              key: const ValueKey("password"),
                              focusNode: passwordFocus,
                              hintText: "Password",
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onChanged: (value) {
                                context.read<LoanBloc>().add(
                                  LoanEvent.passwordChanged(value),
                                );
                              },

                              errorText:
                                  !state.password.isPure &&
                                      state.password.isNotValid
                                  ? "Password is Required"
                                  : null,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.09),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Button(
                            color: AppColors.blueColor,
                            'Continue',
                            onPressed: state.isFormValid
                                ? () {
                                    if (state.selectedPlan == null) {
                                      ToastService.toast(
                                        'Please select a plan',
                                      );
                                      return;
                                    }
                                    final int months = int.parse(
                                      state.selectedPlan!.split('')[0],
                                    );
                                    const double interest = 0.10;
                                    final DateTime now = DateTime.now();
                                    final DateTime dueDate = DateTime(
                                      now.year,
                                      now.month + months,
                                      now.day,
                                    );
                                    final String dueDateFormatted = DateFormat(
                                      'dd MMM yyyy',
                                    ).format(dueDate);

                                    final double principal = loan.amount;
                                    final double totalInterest =
                                        principal * interestRate * months;
                                    final double totalPayment =
                                        principal + totalInterest;
                                    Navigator.pushNamed(
                                      context,
                                      LoanPaymentConfirmation.routeName,
                                      arguments: {
                                        'name': state.name.value,
                                        'cnic': state.cnic.value,
                                        'mobile': state.mobile.value,
                                        'password': state.password.value,
                                        'selectedPlan': state.selectedPlan,
                                        'principal': principal,
                                        'Interest': totalInterest,
                                        'totalPayment': totalPayment,
                                        'dueDate': dueDateFormatted,
                                      },
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _loanPaymentBuildWhen(
    BuildContext context,
    LoanState previous,
    LoanState current,
  ) {
    return previous != current;
  }
}
