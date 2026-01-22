import 'package:esae_monie/blocs/recharge/recharge_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/enums/validator_error.dart';
import 'package:esae_monie/presentation/data/formatter.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/recharge/recharge_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scrollbar.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Recharge extends HookWidget {
  static const String routeName = 'Recharge';
  const Recharge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final amountFocusNode = useFocusNode();
    final TextEditingController amountController = useTextEditingController();
    final TextEditingController phoneController =
        useTextEditingController(); // Add this

    final numberFocus = useFocusNode();
    final paymentOptionsFocus = useFocusNode();

    // Reset form when widget is disposed (navigating away)
    useEffect(() {
      return () {
        context.read<RechargeBloc>().add(const RechargeEvent.resetForm());
      };
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Recharge',
                onTap: () {
                  context.read<RechargeBloc>().add(
                    const RechargeEvent.resetForm(),
                  );
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
                    AppSpacing.verticalSpaceHuge,
                    TextTitle(text: 'Add Mobile Number'),
                    AppSpacing.verticalSpaceSmall,
                    TextChild(text: 'Enter receipent mobile Number'),

                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return CustomTextFormField(
                          controller: phoneController, // Add controller
                          key: const ValueKey("recipient_number"),
                          focusNode: numberFocus,
                          hintText: "Recipient Mobile Number",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            context.read<RechargeBloc>().add(
                              RechargeEvent.phoneNumberChanged(value),
                            );
                          },
                          onFieldSubmitted: (_) =>
                              paymentOptionsFocus.requestFocus(),
                          // Add error text like bank screen
                          errorText:
                              !state.phoneNumber.isPure &&
                                  state.phoneNumber.isNotValid
                              ? state.phoneNumber.error == ValidationError.empty
                                    ? "Phone number is required"
                                    : "Phone number must be at least 6 digits"
                              : null,
                        );
                      },
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    TextTitle(text: 'Select Network'),
                    AppSpacing.verticalSpaceMedium,
                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return CustomHorizontalScrollbar(
                          itemCount: selectedNetwork.length,
                          itemBuilder: (index) {
                            final network = selectedNetwork[index];
                            final isSelected = state.selectedNetwork == network;
                            final theme = Theme.of(context);

                            return GestureDetector(
                              onTap: () {
                                context.read<RechargeBloc>().add(
                                  RechargeEvent.networkSelected(network),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                width:
                                    MediaQuery.of(context).size.width /
                                    selectedNetwork.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary.withOpacity(
                                          0.1,
                                        )
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.dividerColor
                                        : theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                transform: Matrix4.identity()
                                  ..scale(isSelected ? 1.05 : 1.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        network.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    AppSpacing.verticalSpaceMedium,
                                    Text(
                                      network.name,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    TextTitle(text: 'Enter Amount'),
                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return CustomTextFormField(
                          controller: amountController,
                          focusNode: amountFocusNode,
                          hintText: 'Enter Amount',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            final raw = value.replaceAll(
                              RegExp(r'[^0-9.]'),
                              '',
                            );
                            context.read<RechargeBloc>().add(
                              RechargeEvent.amountChanged(raw),
                            );
                          },
                          onFieldSubmitted: (_) {
                            final parsed =
                                double.tryParse(amountController.text) ?? 0;
                            amountController.text = formatter.format(parsed);
                          },
                          // Add error text
                          errorText:
                              !state.amount.isPure && state.amount.isNotValid
                              ? state.amount.error == ValidationError.empty
                                    ? "Amount is required"
                                    : "Please enter a valid amount"
                              : null,
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceMassive,
                    TextTitle(text: 'Quick Actions'),
                    AppSpacing.verticalSpaceSmall,
                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: presetAmounts.map((amt) {
                              final isSelected =
                                  state.amount.value == amt.toString();
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<RechargeBloc>().add(
                                      RechargeEvent.quickAmountSelected(
                                        amt.toString(),
                                      ),
                                    );
                                    // Update controller when quick amount selected
                                    amountController.text = formatter.format(
                                      amt,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.blueColor
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      formatter.format(amt),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Button(
                            color: AppColors.blueColor,
                            'Continue',
                            onPressed: state.isRechargeFormValid
                                ? () {
                                    Navigator.pushNamed(
                                      context,
                                      RechargeConfirmation.routeName,
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
