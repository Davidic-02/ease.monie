import 'package:esae_monie/blocs/gift/gift_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/formatter.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/gift_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

class TypeOfGift extends HookWidget {
  static const String routeName = 'TypeOfGift';
  const TypeOfGift({super.key});

  @override
  Widget build(BuildContext context) {
    final nameFocus = useFocusNode();
    final accountFocus = useFocusNode();
    final purposeFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final amountFocusNode = useFocusNode();
    final messageFocusNode = useFocusNode();
    // final amountController = useTextEditingController();
    final amountController = useTextEditingController();

    return BlocBuilder<GiftBloc, GiftState>(
      buildWhen: (previous, current) =>
          _giftBuildWhen(context, previous, current),

      builder: (context, state) {
        final currentGift = state.giftModel.firstWhere(
          (gift) => gift.id == state.selectedGiftId,
        );

        if (currentGift == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Gift',
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
                                    currentGift.imagePath,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.verticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text(currentGift.title)],
                                ),
                                Text(
                                  currentGift.organizer,
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
                        Text(
                          'Add Receipient Bank Details',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueColor.shade300,
                              ),
                        ),

                        CustomTextFormField(
                          key: const ValueKey("name"),
                          focusNode: nameFocus,
                          hintText: "Name",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,

                          onChanged: (value) {
                            context.read<GiftBloc>().add(
                              GiftEvent.recipientNameChanged(value),
                            );
                          },
                          errorText:
                              !state.recipientName.isPure &&
                                  state.recipientName.isNotValid
                              ? "Name is required"
                              : null,
                          onFieldSubmitted: (_) => accountFocus.requestFocus(),
                        ),
                        CustomTextFormField(
                          key: const ValueKey("account"),
                          focusNode: accountFocus,
                          hintText: "Account Number",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            context.read<GiftBloc>().add(
                              GiftEvent.accountNumberChanged(value),
                            );
                          },
                          errorText:
                              !state.accountNumber.isPure &&
                                  state.accountNumber.isNotValid
                              ? "Account number must be 10 digits."
                              : null,
                          onFieldSubmitted: (_) => purposeFocus.requestFocus(),
                        ),

                        CustomTextFormField(
                          key: const ValueKey("purpose"),
                          focusNode: purposeFocus,
                          hintText: "Purpose",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<GiftBloc>().add(
                              GiftEvent.purposeChanged(value),
                            );
                          },
                          errorText:
                              !state.purpose.isPure && state.purpose.isNotValid
                              ? "Purpose is required"
                              : null,
                          onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                        ),

                        CustomTextFormField(
                          key: const ValueKey("password"),
                          focusNode: passwordFocus,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: (value) {
                            // Dispatch the bloc event for password
                            context.read<GiftBloc>().add(
                              GiftEvent.passwordChanged(value),
                            );
                          },
                          errorText:
                              !state.password.isPure &&
                                  state.password.isNotValid
                              ? "Password is required"
                              : null,
                          onFieldSubmitted: (_) {
                            passwordFocus.unfocus();
                          },
                        ),

                        AppSpacing.verticalSpaceMassive,
                        Text(
                          'Enter Amount',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueColor.shade300,
                              ),
                        ),

                        CustomTextFormField(
                          controller: amountController,

                          focusNode: amountFocusNode,
                          hintText: 'Enter Amount',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            context.read<GiftBloc>().add(
                              GiftEvent.giftAmountChanged(value),
                            );
                          },
                          onFieldSubmitted: (_) {
                            final parsed = double.tryParse(
                              amountController.text,
                            );
                            if (parsed != null) {
                              amountController.text = formatter.format(parsed);
                            }
                          },
                          errorText:
                              !state.amount.isPure && state.amount.isNotValid
                              ? "Enter a valid amount"
                              : null,
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: presetAmounts.map((amt) {
                              final isSelected =
                                  state.amount.value == amt.toString();
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),

                                child: GestureDetector(
                                  onTap: () {
                                    amountController.text = formatter.format(
                                      amt,
                                    );

                                    context.read<GiftBloc>().add(
                                      GiftEvent.quickAmountSelected(amt),
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
                        ),

                        AppSpacing.verticalSpaceMassive,
                        Text(
                          'Enter Gift Message',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueColor.shade300,
                              ),
                        ),

                        CustomTextFormField(
                          key: const ValueKey("gift_message"),
                          focusNode: messageFocusNode,
                          hintText: "Write your gift message here...",
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 4,
                          maxLines: 6,
                          onChanged: (value) {
                            context.read<GiftBloc>().add(
                              GiftEvent.giftMessageChanged(value),
                            );
                          },
                          errorText:
                              !state.giftMessage.isPure &&
                                  state.giftMessage.isNotValid
                              ? "Gift message cannot be empty"
                              : null,
                        ),

                        AppSpacing.verticalSpaceMedium,
                        Button(
                          'Send',
                          color: AppColors.blueColor,
                          onPressed: state.isGiftFormValid
                              ? () {
                                  Navigator.pushNamed(
                                    context,
                                    GiftConfirmation.routeName,
                                  );
                                }
                              : null,
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

  bool _giftBuildWhen(
    BuildContext context,
    GiftState previous,
    GiftState current,
  ) {
    if (previous.submissionStatus != current.submissionStatus &&
        current.submissionStatus.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.toast('Gift submitted successfully!');
      });
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.toast('${current.errorMessage}', ToastType.error);
      });
      return true;
    }

    if (previous.recipientName != current.recipientName) return true;
    if (previous.accountNumber != current.accountNumber) return true;
    if (previous.purpose != current.purpose) return true;
    if (previous.password != current.password) return true;
    if (previous.amount != current.amount) return true;
    if (previous.giftMessage != current.giftMessage) return true;

    if (previous.selectedGiftId != current.selectedGiftId) return true;

    return false;
  }
}
