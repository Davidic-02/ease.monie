import 'package:esae_monie/blocs/insurance/insurance_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/type_of_insurance.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/service_option_card.dart';
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
            AppSpacing.verticalSpaceMedium,
            Expanded(
              child: BlocBuilder<InsuranceBloc, InsuranceState>(
                builder: (context, state) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final insurance = state.insuranceModel[index];
                      return ServiceOptionCard(
                        onPressed: () {
                          context.read<InsuranceBloc>().add(
                            InsuranceEvent.selectInsurance(insurance.id),
                          );
                          Navigator.pushNamed(
                            context,
                            TypeOfInsurance.routeName,
                            arguments: insurance,
                          );
                        },
                        imagePath: insurance.imagePath,
                        title: insurance.title,
                        subTitle: insurance.organizer,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return AppSpacing.verticalSpaceMedium;
                    },
                    itemCount: state.insuranceModel.length,
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
