import 'package:esae_monie/blocs/bank_transfer/bank_transfer_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BankToBank extends HookWidget {
  const BankToBank({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
              TextTitle(text: 'Transfer to Bank'),
              AppSpacing.verticalSpaceSmall,
              TextChild(text: 'Search or select Receiptient Banks'),
              AppSpacing.verticalSpaceMedium,
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
              AppSpacing.verticalSpaceMedium,

              BlocBuilder<BankTransferBloc, BankTransferState>(
                builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      final bank = banks[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Image.asset(bank.imagePath, width: 40),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                bank.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Radio<String>(
                              value: bank.name,
                              groupValue: state.selectedBank,
                              onChanged: (value) {
                                context.read<BankTransferBloc>().add(
                                  BankTransferEvent.bankChanged(value!),
                                );
                              },
                              activeColor: Colors.blue, // blue when selected
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.13),
              BlocBuilder<BankTransferBloc, BankTransferState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Button(
                      color: AppColors.blueColor,
                      'Continue',
                      onPressed: state.selectedBank != null
                          ? () {
                              // Your action when a bank is selected
                              debugPrint(
                                'Selected bank: ${state.selectedBank}',
                              );
                            }
                          : null, // disables the button automatically
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
