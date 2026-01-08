import 'package:esae_monie/blocs/bank_transfer/bank_transfer_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BankInformation extends HookWidget {
  const BankInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final cardNameFocus = useFocusNode();
    final cardNumberFocus = useFocusNode();
    final expiryFocus = useFocusNode();
    final cvvFocus = useFocusNode();
    return Scaffold(
      body: BlocBuilder<BankTransferBloc, BankTransferState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTopbar(
                    title: 'Money Transfer',
                    onTap: () => Navigator.pop(context),
                  ),
                  TextTitle(text: 'Add Account Detils'),
                  CustomTextFormField(
                    keyboardType: TextInputType.name,
                    focusNode: cardNameFocus,
                    hintText: 'Card Holder Name',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => context.read<BankTransferBloc>().add(
                      BankTransferEvent.cardHolderNameChanged(value),
                    ),
                    onFieldSubmitted: (_) => cardNumberFocus.requestFocus(),
                  ),

                  CustomTextFormField(
                    focusNode: cardNumberFocus,
                    hintText: 'Card Number',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => context.read<BankTransferBloc>().add(
                      BankTransferEvent.cardNumberChanged(value),
                    ),
                    onFieldSubmitted: (_) => expiryFocus.requestFocus(),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          focusNode: expiryFocus,
                          hintText: 'MM/YY',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context
                              .read<BankTransferBloc>()
                              .add(BankTransferEvent.expiryChanged(value)),
                          onFieldSubmitted: (_) => cvvFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.horizontalSpaceSmall,
                      Expanded(
                        child: CustomTextFormField(
                          focusNode: cvvFocus,
                          hintText: 'CVV',
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          onChanged: (value) => context
                              .read<BankTransferBloc>()
                              .add(BankTransferEvent.cvvChanged(value)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
