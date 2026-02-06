import 'package:esae_monie/blocs/insurance/insurance_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/insurance_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InsuranceInfomation extends HookWidget {
  static const String routeName = 'InsuranceInformation';
  const InsuranceInfomation({super.key});

  @override
  Widget build(BuildContext context) {
    final cardNameFocus = useFocusNode();
    final cardNumberFocus = useFocusNode();
    final expiryFocus = useFocusNode();
    final cvvFocus = useFocusNode();
    final nameFocus = useFocusNode();
    final lastNameFocus = useFocusNode();
    final familyFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final purposeFocus = useFocusNode();

    return BlocBuilder<InsuranceBloc, InsuranceState>(
      builder: (context, state) {
        final insuranceIndex = state.insuranceModel.indexWhere(
          (insurance) => insurance.id == state.selectedInsuranceId,
        );

        if (insuranceIndex == -1) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentInsurance = state.insuranceModel[insuranceIndex];
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Insurance',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.verticalSpaceHuge,

                        // Insurance Card Display
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    currentInsurance.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.verticalSpaceMedium,
                                Text(
                                  currentInsurance.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  currentInsurance.organizer,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        AppSpacing.verticalSpaceMassive,

                        // Personal Information Section
                        TextTitle(text: 'Add Information'),
                        CustomTextFormField(
                          key: const ValueKey("firstName"),
                          focusNode: nameFocus,
                          hintText: "First Name",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.firstNameChanged(value),
                            );
                          },
                          errorText:
                              !state.firstName.isPure &&
                                  state.firstName.isNotValid
                              ? "First name is required"
                              : null,
                          onFieldSubmitted: (_) => lastNameFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("lastName"),
                          focusNode: lastNameFocus,
                          hintText: "Last Name",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.lastNameChanged(value),
                            );
                          },
                          errorText:
                              !state.lastName.isPure &&
                                  state.lastName.isNotValid
                              ? "Last name is required"
                              : null,
                          onFieldSubmitted: (_) => familyFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("family"),
                          focusNode: familyFocus,
                          hintText: "Total Family Members",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.familyMembersChanged(value),
                            );
                          },
                          errorText:
                              !state.familyMembers.isPure &&
                                  state.familyMembers.isNotValid
                              ? "Total family members is required"
                              : null,
                          onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("password"),
                          focusNode: passwordFocus,
                          hintText: "Password",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.passwordChanged(value),
                            );
                          },
                          errorText:
                              !state.password.isPure &&
                                  state.password.isNotValid
                              ? "Password is required (min 4 characters)"
                              : null,
                          onFieldSubmitted: (_) => purposeFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("purpose"),
                          focusNode: purposeFocus,
                          hintText: "Purpose of Payment",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.purposeChanged(value),
                            );
                          },
                          errorText:
                              !state.purpose.isPure && state.purpose.isNotValid
                              ? "Purpose is required"
                              : null,
                          onFieldSubmitted: (_) => cardNameFocus.requestFocus(),
                        ),

                        AppSpacing.verticalSpaceMassive,

                        // Card Details Section
                        TextTitle(text: 'Add Account Details'),
                        CustomTextFormField(
                          key: const ValueKey("cardName"),
                          focusNode: cardNameFocus,
                          hintText: "Card Holder Name",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.cardNameChanged(value),
                            );
                          },
                          errorText:
                              !state.cardName.isPure &&
                                  state.cardName.isNotValid
                              ? "Card name is required"
                              : null,
                          onFieldSubmitted: (_) =>
                              cardNumberFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("cardNumber"),
                          focusNode: cardNumberFocus,
                          hintText: "Card Number",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<InsuranceBloc>().add(
                              InsuranceEvent.cardNumberChanged(value),
                            );
                          },
                          errorText:
                              !state.cardNumber.isPure &&
                                  state.cardNumber.isNotValid
                              ? "Card number is required (16 digits)"
                              : null,
                          onFieldSubmitted: (_) => expiryFocus.requestFocus(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                key: const ValueKey("expiry"),
                                focusNode: expiryFocus,
                                hintText: "MM/YY",
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  context.read<InsuranceBloc>().add(
                                    InsuranceEvent.cardExpiryChanged(value),
                                  );
                                },
                                errorText:
                                    !state.expiry.isPure &&
                                        state.expiry.isNotValid
                                    ? "Invalid format"
                                    : null,
                                onFieldSubmitted: (_) =>
                                    cvvFocus.requestFocus(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextFormField(
                                key: const ValueKey("cvv"),
                                focusNode: cvvFocus,
                                hintText: "CVV",
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                onChanged: (value) {
                                  context.read<InsuranceBloc>().add(
                                    InsuranceEvent.cardCvvChanged(value),
                                  );
                                },
                                errorText:
                                    !state.cvv.isPure && state.cvv.isNotValid
                                    ? "Required"
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.verticalSpaceMassive,

                        // Payment Plan Selection
                        TextTitle(text: 'Payment Plan'),
                        AppSpacing.verticalSpaceMedium,
                        Row(
                          children: paymentPlan.map((plan) {
                            final isSelected = state.paymentPlan.value == plan;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.read<InsuranceBloc>().add(
                                    InsuranceEvent.paymentPlanChanged(plan),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.blueColor
                                        : Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    plan,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        AppSpacing.verticalSpaceHuge,

                        // Continue Button - just navigate, don't submit
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Button(
                            color: AppColors.blueColor,
                            'Continue',
                            onPressed: state.paymentPlan.value.isEmpty
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      InsuranceConfirmation.routeName,
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
