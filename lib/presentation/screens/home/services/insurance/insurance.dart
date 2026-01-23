import 'package:esae_monie/blocs/insurance/insurance_bloc.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/type_of_insurance.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Insurance extends HookWidget {
  static const String routeName = 'Insurance';
  const Insurance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Insurance',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<InsuranceBloc, InsuranceState>(
                builder: (context, state) {
                  final insurances = state.insurances.values.toList();
                  if (insurances.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: insurances.map((insurance) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: ServiceCard(
                            service: insurance,
                            showProgressBar: false,
                            showPercentageBadge: false,
                            buttonText: 'Send',
                            bottomLeftText: getCashbackText(insurance.id),
                            onButtonPressed: () {
                              context.read<InsuranceBloc>().add(
                                InsuranceEvent.selectInsurance(insurance.id),
                              );
                              Navigator.pushNamed(
                                context,
                                TypeOfInsurance.routeName,
                                arguments: insurance,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
