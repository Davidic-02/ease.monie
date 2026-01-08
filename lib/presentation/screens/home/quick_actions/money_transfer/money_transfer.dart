// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:esae_monie/presentation/screens/home/quick_actions/money_transfer/payment_managements/amounts.dart';
import 'package:esae_monie/presentation/widgets/b_sheets/transfer_money_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

import 'package:esae_monie/blocs/bank_verification/bank_verification_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scroll.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/services/toast_services.dart';

class MoneyTransfer extends HookWidget {
  static const String routeName = 'MoneyTransfer';

  const MoneyTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final bloc = context.read<VerificationBloc>();
      if (bloc.state.banks.isEmpty) {
        bloc.add(const VerificationEvent.getBanks());
      }
      return null;
    }, []);

    final accountNumberFocusNode = useFocusNode();
    final bankFocusNode = useFocusNode();
    final modalFocusNode = useFocusNode();
    final searchStringController = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
                  final accountName = state.verifiedAccountName;

                  return Column(
                    children: [
                      CustomTextFormField(
                        focusNode: accountNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        hintText: "Account Number",
                        keyboardType: TextInputType.number,

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

                      GestureDetector(
                        onTap: () =>
                            showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (_) => TransferMoneyBottomSheet(
                                modalFocusNode: modalFocusNode,
                                searchStringController: searchStringController,
                              ),
                            ).whenComplete(() {
                              searchStringController.clear();
                              context.read<VerificationBloc>().add(
                                const VerificationEvent.searchBankString(''),
                              );
                            }),

                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            focusNode: bankFocusNode,
                            keyboardType: TextInputType.name,
                            hintText:
                                state.selectedBank.value?.name ?? 'Select Bank',
                          ),
                        ),
                      ),

                      if (accountName != null) AppSpacing.verticalSpaceSmall,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: (accountName?.isNotEmpty ?? false)
                            ? Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Account Name: $accountName',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.toast('Account Verified Successfully!');
        final accountName = current.verifiedAccountName;
        final bankName = current.selectedBank.value?.name;
        final accountNumber = current.bankAccount.value;

        Navigator.pushNamed(
          context,
          Amount.routeName,
          arguments: {
            'accountName': accountName,
            'bankName': bankName,
            'accountNumber': accountNumber,
          },
        );
      });
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      // Schedule toast to show AFTER build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.toast('${current.errorMessage}', ToastType.error);
      });
      return true;
    }

    if (previous.bankAccount != current.bankAccount) return true;
    if (previous.selectedBank != current.selectedBank) return true;

    if (previous.formzStatus != current.formzStatus) return true;

    if (previous.banks != current.banks) return true;
    return false;
  }
}
