import 'package:esae_monie/blocs/scan/scan_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class Scan extends HookWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopbar(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profilepic.png'),
                ),
                title: 'QR Scan',
              ),
              AppSpacing.verticalSpaceMedium,
              BlocBuilder<ScanBloc, ScanState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Animation
                      Lottie.asset(
                        'assets/lottie/Scanner.json',
                        repeat: true,
                        animate: state.isScanning,
                      ),

                      const SizedBox(height: 10),

                      // Text
                      Text(state.message),

                      // Refresh
                      IconButton(
                        onPressed: () {
                          context.read<ScanBloc>().add(
                            const ScanEvent.refresh(),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      Text(
                        'The QR code will be automatically detected when you place the QR code inside the frame',
                        textAlign: TextAlign.center,
                      ),
                      // Scan button
                      AppSpacing.verticalSpaceMassive,
                      Button(
                        color: AppColors.blueColor,
                        'Scan',
                        onPressed: () {
                          context.read<ScanBloc>().add(const ScanEvent.scan());
                        },
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
}
