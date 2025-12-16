import 'package:esae_monie/blocs/bank_verification/bank_verification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanksList extends StatelessWidget {
  final VerificationState state;
  const BanksList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.computedBanks.length,
        itemBuilder: (_, index) {
          final bank = state.computedBanks[index];
          return ListTile(
            title: Text(bank.name),
            onTap: () {
              context.read<VerificationBloc>().add(
                VerificationEvent.bankChanged(bank),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
