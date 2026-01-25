import 'package:esae_monie/blocs/gift/gift_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/home/services/gift/type_of_gift.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/service_option_card.dart';
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
                onTap: () => Navigator.pop(context),
              ),
            ),
            AppSpacing.verticalSpaceMedium,
            BlocBuilder<GiftBloc, GiftState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final gift = state.giftModel[index];
                      return ServiceOptionCard(
                        cashBack: gift.cashBack,
                        onPressed: () {
                          context.read<GiftBloc>().add(
                            GiftEvent.selectGift(gift.id),
                          );
                          Navigator.pushNamed(
                            context,
                            TypeOfGift.routeName,
                            arguments: gift,
                          );
                        },
                        imagePath: gift.imagePath,
                        title: gift.title,
                        subTitle: gift.organizer,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return AppSpacing.verticalSpaceMedium;
                    },
                    itemCount: state.giftModel.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
