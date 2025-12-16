import 'package:esae_monie/blocs/bank_verification/bank_verification_bloc.dart';
import 'package:esae_monie/presentation/widgets/banks_list.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/empty_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferMoneyBottomSheet extends StatelessWidget {
  const TransferMoneyBottomSheet({
    super.key,
    required this.modalFocusNode,
    required this.searchStringController,
  });

  final FocusNode modalFocusNode;
  final TextEditingController searchStringController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextFormField(
                focusNode: modalFocusNode,
                controller: searchStringController,
                hintText: 'Search Banks...',
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  context.read<VerificationBloc>().add(
                    VerificationEvent.searchBankString(value),
                  );
                },
              ),
            ),
            state.computedBanks.isEmpty ? EmptyText() : BanksList(state: state),
          ],
        );
      },
    );
  }
}
