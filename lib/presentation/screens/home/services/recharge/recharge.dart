import 'package:esae_monie/blocs/recharge/recharge_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
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

    final numberFocus = useFocusNode();
    final paymentOptionsFocus = useFocusNode();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Recharge',
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
                    AppSpacing.verticalSpaceHuge,
                    TextTitle(text: 'Add Mobile Number'),
                    AppSpacing.verticalSpaceSmall,
                    TextChild(text: 'Enter receipent mobile Number'),

                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        return CustomTextFormField(
                          key: const ValueKey("recipient_number"),
                          focusNode: numberFocus,
                          hintText: "Recipient Mobile Number",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            context.read().add(
                              RechargeEvent.phoneNumberChanged(value),
                            );
                          },

                          errorText: state.phoneNumber.isNotValid
                              ? "Mobile number required"
                              : null,
                          onFieldSubmitted: (_) =>
                              paymentOptionsFocus.requestFocus(),
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
                            final parsed = double.tryParse(raw) ?? 0;
                            final formatted = formatter.format(parsed);

                            // Only update controller if needed to avoid infinite loop
                            if (amountController.text != formatted) {
                              amountController.text = formatted;
                              amountController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: amountController.text.length,
                                    ),
                                  );
                            }
                          },

                          errorText: state.amount.isNotValid
                              ? 'Invalid amount'
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
                              final isSelected = state.amount.value == amt;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<RechargeBloc>().add(
                                      RechargeEvent.quickAmountSelected(
                                        amt.toString(),
                                      ),
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
