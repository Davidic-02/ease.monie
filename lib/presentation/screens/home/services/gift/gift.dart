import 'package:esae_monie/blocs/gift/gift_bloc.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/type_of_gift.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Gift extends HookWidget {
  static const String routeName = 'Gift';
  const Gift({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Gift',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<GiftBloc, GiftState>(
                builder: (context, state) {
                  final gifts = state.gifts.values.toList();
                  if (gifts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: gifts.map((gift) {
                        return Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: ServiceCard(
                            service: gift,
                            showProgressBar: false,
                            showPercentageBadge: false,
                            buttonText: 'Send',
                            bottomLeftText: '🎁 Cashback Available',
                            onButtonPressed: () {
                              context.read<GiftBloc>().add(
                                GiftEvent.selectGift(gift.id),
                              );

                              Navigator.pushNamed(
                                context,
                                TypeOfGift.routeName,
                                arguments: gift.id,
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
