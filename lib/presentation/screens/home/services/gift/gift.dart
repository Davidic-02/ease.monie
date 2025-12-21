import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Charity extends HookWidget {
  static const String routeName = 'Charity';
  const Charity({super.key});

  @override
  Widget build(BuildContext context) {
    final charity1 = useState(
      ServicesModel(
        imagePath: 'assets/images/child_education.png',
        title: 'Donate For Child Education',
        organizer: 'Arrange by HEADS Foundation',
        targetAmount: 1000000,
        donatedAmount: 25000,
      ),
    );

    final charity2 = useState(
      ServicesModel(
        imagePath: 'assets/images/cancer_patient.png',
        title: 'Donate For Cancer Patients',
        organizer: 'Arrange by Care Club',
        targetAmount: 1000000,
        donatedAmount: 15000,
      ),
    );

    final color = charity1.value.getDonationColor(context);
    final color2 = charity2.value.getDonationColor(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Charity',
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
                                charity1.value.imagePath,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppSpacing.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ],
                        ),
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
  }
}
