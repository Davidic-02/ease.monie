import 'package:esae_monie/blocs/bank_verification/verification_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/models/bank_model.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scroll.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

class MoneyTransfer extends HookWidget {
  static const String routeName = 'MoneyTransfer';

  const MoneyTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final bloc = context.read<VerificationBloc>();
      if (bloc.state.banks.isEmpty) {
        bloc.add(const VerificationEvent.loadBanks());
      }
      return null;
    }, []);

    final accountNumberFocusNode = useFocusNode();
    final bankFocusNode = useFocusNode();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopbar(
                title: 'Money Transfer',
                onTap: () => Navigator.pop(context),
              ),
              AppSpacing.verticalSpaceHuge,
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: context.theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  debugPrint("Searching for: $value");
                },
              ),
              AppSpacing.verticalSpaceHuge,
              Text(
                'Recent Transfers',
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  //  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              AppSpacing.verticalSpaceSmall,
              CustomHorizontalscroll(
                itemCount: recentTransfer.length,
                itemBuilder: (index) {
                  final transfer = recentTransfer[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(transfer.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          AppSpacing.verticalSpaceMedium,
                          Text(
                            transfer.name,
                            style: context.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              //  color: Colors.white,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            transfer.amount,
                            style: context.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              //  color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onTap: (index) {
                  final tapped = recentTransfer[index];
                  //     ToastService.toast(tapped);
                },
              ),

              AppSpacing.verticalSpaceHuge,
              Text(
                'Make New Transfer',
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  //  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              BlocBuilder<VerificationBloc, VerificationState>(
                buildWhen: (previous, current) {
                  return _verificationBuildWhen(context, previous, current);
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomTextFormField(
                        focusNode: accountNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        hintText: "Account Number",
                        keyboardType: TextInputType.number,
                        fillColor: AppColors.whiteColor,

                        onFieldSubmitted: (_) {
                          bankFocusNode.requestFocus(); // go to bank dropdown
                        },

                        onChanged: (value) {
                          context.read<VerificationBloc>().add(
                            VerificationEvent.bankAccountChanged(value),
                          );
                        },

                        errorText:
                            !state.bankAccount.isPure &&
                                state.bankAccount.isNotValid
                            ? "Account number must be 10 digits."
                            : null,
                      ),

                      AppSpacing.verticalSpaceMedium,
                      Focus(
                        focusNode: bankFocusNode,
                        child: SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<Bank>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              border: OutlineInputBorder(),
                            ),
                            value: state.selectedBank.value,
                            items: state.banks.map((bank) {
                              return DropdownMenuItem(
                                value: bank,
                                child: Text(
                                  bank.name,
                                  overflow: TextOverflow.ellipsis, // ADD THIS
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<VerificationBloc>().add(
                                  VerificationEvent.bankChanged(value),
                                );
                              }
                            },
                            validator: (_) {
                              if (!state.selectedBank.isPure &&
                                  state.selectedBank.isNotValid) {
                                return "Please select a bank.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      AppSpacing.verticalSpaceMassive,
                      Button(
                        'Verify',
                        onPressed: () {
                          context.read<VerificationBloc>().add(
                            const VerificationEvent.submit(),
                          );
                        },

                        busy:
                            state.formzStatus ==
                            FormzSubmissionStatus.inProgress,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _verificationBuildWhen(
    BuildContext context,
    VerificationState previous,
    VerificationState current,
  ) {
    if (previous.formzStatus != current.formzStatus &&
        current.formzStatus.isSuccess &&
        current.bankAccount.isValid) {
      ToastService.toast('Account Verified Successfully!');
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      ToastService.toast('${current.errorMessage}', ToastType.error);

      context.read<VerificationBloc>().add(
        const VerificationEvent.submitFailed('Failed to verify Account'),
      );

      return true;
    }

    if (previous.bankAccount != current.bankAccount) return true;
    if (previous.selectedBank != current.selectedBank) return true;

    // REBUILD FOR IN-PROGRESS
    if (previous.formzStatus != current.formzStatus) return true;

    return false;
  }
}
