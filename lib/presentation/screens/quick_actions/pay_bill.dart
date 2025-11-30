import 'package:esae_monie/blocs/paybill/paybill_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/bill_options.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/services/logging_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

class PayBill extends HookWidget {
  const PayBill({super.key});
  static const String routeName = 'pay_bill';
  @override
  Widget build(BuildContext context) {
    final nameFocus = useFocusNode();
    final accountFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final providerFocus = useFocusNode();
    final meterFocus = useFocusNode();
    final customerFocus = useFocusNode();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PayBillBloc, PayBillState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.horizontalSpacing),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTopbar(title: 'Pay Bill'),
                    AppSpacing.verticalSpaceHuge,
                    const Text(
                      "Select Bill Type",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalSpaceMedium,
                    BillOption(
                      selected: state.selectedBill == 'Internet',
                      image: 'internet_bill',
                      label: 'Internet Bill',
                      onTap: () {
                        logInfo(state.selectedBill);
                        context.read<PayBillBloc>().add(
                          PayBillEvent.billTypeChanged('Internet'),
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceSmall,
                    BillOption(
                      selected: state.selectedBill == 'Electricity',
                      image: 'electricity',
                      label: 'Electricity Bill',
                      onTap: () {
                        logInfo(state.selectedBill);
                        context.read<PayBillBloc>().add(
                          PayBillEvent.billTypeChanged('Electricity'),
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceSmall,

                    BillOption(
                      selected: state.selectedBill == 'Water',
                      image: 'water_bill',
                      label: 'Water Bill',
                      onTap: () {
                        logInfo(state.selectedBill);
                        context.read<PayBillBloc>().add(
                          PayBillEvent.billTypeChanged('Water'),
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceSmall,

                    BillOption(
                      selected: state.selectedBill == 'Others',
                      image: 'category',
                      label: 'Others',
                      onTap: () {
                        logInfo(state.selectedBill);
                        context.read<PayBillBloc>().add(
                          PayBillEvent.billTypeChanged('Others'),
                        );
                      },
                    ),

                    AppSpacing.verticalSpaceMassive,

                    // Internet Bill Form
                    if (state.selectedBill == 'Internet') ...[
                      const Text(
                        "Internet Bill Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceMedium,

                      CustomTextFormField(
                        focusNode: nameFocus,
                        hintText: "Name",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) {
                          context.read<PayBillBloc>().add(
                            PayBillEvent.nameChanged(value),
                          );
                        },
                        errorText:
                            !state.internetName.isPure &&
                                state.internetName.isNotValid
                            ? "Name is required"
                            : null,
                        onFieldSubmitted: (_) => accountFocus.requestFocus(),
                      ),
                      AppSpacing.verticalSpaceSmall,

                      CustomTextFormField(
                        focusNode: accountFocus,
                        hintText: "Account Number",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) {
                          context.read<PayBillBloc>().add(
                            PayBillEvent.accountNumberChanged(value),
                          );
                        },
                        errorText:
                            !state.accountNumber.isPure &&
                                state.accountNumber.isNotValid
                            ? "Invalid account number"
                            : null,
                        onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                      ),
                      AppSpacing.verticalSpaceSmall,

                      CustomTextFormField(
                        focusNode: passwordFocus,
                        hintText: "Password",
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) {
                          context.read<PayBillBloc>().add(
                            PayBillEvent.passwordChanged(value),
                          );
                        },
                        errorText:
                            !state.password.isPure && state.password.isNotValid
                            ? "Password must be at least 6 characters"
                            : null,
                      ),
                    ],

                    // Electricity Bill Form
                    if (state.selectedBill == "Electricity") ...[
                      const Text(
                        "Electricity Bill Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceMedium,

                      CustomTextFormField(
                        focusNode: providerFocus,
                        keyboardType: TextInputType.text,
                        hintText: "Provider",
                        textInputAction: TextInputAction.next,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) => context.read<PayBillBloc>().add(
                          PayBillEvent.providerChanged(value),
                        ),
                        errorText:
                            !state.provider.isPure && state.provider.isNotValid
                            ? "Provider is required"
                            : null,
                        onFieldSubmitted: (_) => meterFocus.requestFocus(),
                      ),
                      AppSpacing.verticalSpaceSmall,

                      CustomTextFormField(
                        focusNode: meterFocus,
                        hintText: "Meter Number",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) => context.read<PayBillBloc>().add(
                          PayBillEvent.meterNumberChanged(value),
                        ),
                        errorText:
                            !state.meterNumber.isPure &&
                                state.meterNumber.isNotValid
                            ? "Invalid meter number"
                            : null,
                      ),
                    ],

                    if (state.selectedBill == "Water") ...[
                      const Text(
                        "Water Bill Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceMedium,

                      CustomTextFormField(
                        keyboardType: TextInputType.number,
                        focusNode: customerFocus,
                        hintText: "Customer ID",
                        textInputAction: TextInputAction.done,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) => context.read<PayBillBloc>().add(
                          PayBillEvent.customerIdChanged(value),
                        ),
                        errorText:
                            !state.customerId.isPure &&
                                state.customerId.isNotValid
                            ? "Invalid customer ID"
                            : null,
                      ),
                    ],

                    // Others Form
                    if (state.selectedBill == "Others") ...[
                      const Text(
                        "Other Bill Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.verticalSpaceMedium,

                      CustomTextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: nameFocus,
                        hintText: "Name",
                        textInputAction: TextInputAction.done,
                        fillColor: AppColors.whiteColor,
                        onChanged: (value) => context.read<PayBillBloc>().add(
                          PayBillEvent.nameChanged(value),
                        ),
                        errorText:
                            !state.internetName.isPure &&
                                state.internetName.isNotValid
                            ? "Name is required"
                            : null,
                      ),
                    ],

                    AppSpacing.verticalSpaceMassive,

                    Button(
                      'Next',
                      onPressed: () {
                        context.read<PayBillBloc>().add(
                          const PayBillEvent.submit(),
                        );
                      },
                      color: Colors.blueAccent,
                      busy:
                          state.billSubmissionStatus ==
                          FormzSubmissionStatus.inProgress,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
