import 'package:esae_monie/blocs/charity/charity_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/donation.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Charity extends HookWidget {
  static const String routeName = 'Charity';
  const Charity({super.key});

  @override
  Widget build(BuildContext context) {
    final deadline = DateTime.now().add(const Duration(days: 7));
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

                    BlocBuilder<CharityBloc, CharityState>(
                      builder: (context, state) {
                        // Don't use fallback to static charity1 - force it to use bloc state
                        final currentCharity = state.charities[charity1.id];

                        // If not in state yet, show loading
                        if (currentCharity == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ServiceCard(
                          service: currentCharity,
                          deadlineDate: deadline,
                          showProgressBar: true,
                          showPercentageBadge: true,
                          buttonText: 'Donate',
                          onButtonPressed: () async {
                            final bloc = context.read<CharityBloc>();

                            bloc.add(
                              CharityEvent.selectCharity(currentCharity.id),
                            );

                            await bloc.stream.first;

                            if (context.mounted) {
                              Navigator.pushNamed(context, Donation.routeName);
                            }
                          },
                        );
                      },
                    ),

                    AppSpacing.verticalSpaceHuge,

                    BlocBuilder<CharityBloc, CharityState>(
                      builder: (context, state) {
                        // Don't use fallback to static charity1 - force it to use bloc state
                        final currentCharity = state.charities[charity1.id];

                        // If not in state yet, show loading
                        if (currentCharity == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ServiceCard(
                          service: currentCharity,
                          deadlineDate: deadline,
                          showProgressBar: true,
                          showPercentageBadge: true,
                          buttonText: 'Donate',
                          onButtonPressed: () async {
                            final bloc = context.read<CharityBloc>();

                            bloc.add(
                              CharityEvent.selectCharity(currentCharity.id),
                            );

                            await bloc.stream.first;

                            if (context.mounted) {
                              Navigator.pushNamed(context, Donation.routeName);
                            }
                          },
                        );
                      },
                    ),
                    AppSpacing.verticalSpaceMedium,

                    BlocBuilder<CharityBloc, CharityState>(
                      builder: (context, state) {
                        // Don't use fallback to static charity1 - force it to use bloc state
                        final currentCharity = state.charities[charity1.id];

                        // If not in state yet, show loading
                        if (currentCharity == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ServiceCard(
                          service: currentCharity,
                          deadlineDate: deadline,
                          showProgressBar: true,
                          showPercentageBadge: true,
                          buttonText: 'Donate',
                          onButtonPressed: () async {
                            final bloc = context.read<CharityBloc>();

                            bloc.add(
                              CharityEvent.selectCharity(currentCharity.id),
                            );

                            await bloc.stream.first;

                            if (context.mounted) {
                              Navigator.pushNamed(context, Donation.routeName);
                            }
                          },
                        );
                      },
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
