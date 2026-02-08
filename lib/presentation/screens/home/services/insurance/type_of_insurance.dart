import 'package:esae_monie/blocs/insurance/insurance_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/insurance_infomation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TypeOfInsurance extends HookWidget {
  static const String routeName = 'TypeOfInsurance';

  const TypeOfInsurance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsuranceBloc, InsuranceState>(
      buildWhen: (previous, current) => _insuranceBuildWhen(previous, current),
      builder: (context, state) {
        final insuranceIndex = state.insuranceModel.indexWhere(
          (insurance) => insurance.id == state.selectedInsuranceId,
        );

        if (insuranceIndex == -1) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentInsurance = state.insuranceModel[insuranceIndex];

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Insurance',
                    onTap: () => Navigator.pop(context),
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
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: .08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    currentInsurance.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.verticalSpaceMedium,
                                Text(
                                  currentInsurance.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  currentInsurance.organizer,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: .6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        AppSpacing.verticalSpaceMassive,

                        Text(
                          'Select Insurance Plan',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueColor.shade300,
                              ),
                        ),

                        AppSpacing.verticalSpaceMedium,

                        /// INSURANCE OPTIONS
                        ...List.generate(insuranceModel.length, (index) {
                          final insurance = insuranceModel[index];
                          final isSelected =
                              state.selectedInsurancePlan?.id == insurance.id;

                          return GestureDetector(
                            onTap: () {
                              context.read<InsuranceBloc>().add(
                                InsuranceEvent.insurancePlanChanged(insurance),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Theme.of(context).cardColor,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// TEXT
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            insurance.plan,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          AppSpacing.verticalSpaceTiny,
                                          Text(
                                            '${insurance.amount} / ${insurance.time}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),

                                      /// CIRCULAR CHECKBOX
                                      Checkbox(
                                        value: isSelected,
                                        shape: const CircleBorder(),
                                        activeColor: AppColors.blueColor,
                                        onChanged: (value) {
                                          context.read<InsuranceBloc>().add(
                                            InsuranceEvent.insurancePlanChanged(
                                              insurance,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        AppSpacing.verticalSpaceSmall,

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 40,
                          ),
                          child: Button(
                            'Continue',
                            color: AppColors.blueColor,
                            onPressed: state.selectedInsurancePlan == null
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      InsuranceInfomation.routeName,
                                    );
                                  },
                          ),
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

  bool _insuranceBuildWhen(InsuranceState previous, InsuranceState current) {
    if (previous.selectedInsurancePlan != current.selectedInsurancePlan) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastService.toast('Insurance plan selected!');
      });
      return true;
    }
    return false;
  }
}
