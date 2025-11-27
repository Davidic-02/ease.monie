import 'package:esae_monie/blocs/auth/auth_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scroll.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scrollbar.dart';
import 'package:esae_monie/presentation/widgets/custom_vertical_scrolls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class Home extends HookWidget {
  static const String routeName = 'Home';
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final selectedService = useState<int?>(null);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                  title: 'Fintech',
                ),
                AppSpacing.verticalSpaceMedium,
                SizedBox(
                  height: 228,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Stack(
                          children: [
                            Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(right: 10.0)
                                  : EdgeInsets.only(left: 10.0),
                              child: SvgPicture.asset(
                                'assets/svgs/home_card.svg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            if (index == 0)
                              Positioned(
                                left: 16,
                                top: 16,
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    if (state.loginStatus.isInProgress) {
                                      return const CircularProgressIndicator(
                                        color: Colors.white,
                                      );
                                    }

                                    if (state.user == null) {
                                      return const Text(
                                        "Loading user...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }

                                    final user = state.user!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Card Holder'),
                                        AppSpacing.verticalSpaceSmall,
                                        Text(
                                          user.displayName ?? 'User',
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            else
                              Positioned(
                                left: 16,
                                bottom: 16,

                                child: Text(
                                  "Savings Account",
                                  style: TextStyle(
                                    color: AppColors.lighterWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                AppSpacing.verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage.value == index ? 24 : 8,
                      height: 5,
                      decoration: BoxDecoration(
                        color: currentPage.value == index
                            ? Colors.blue
                            : AppColors.greyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                AppSpacing.verticalSpaceMassive,
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                AppSpacing.verticalSpaceMedium,
                CustomHorizontalScrollbar(
                  itemCount: 3,
                  itemBuilder: (index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 80,
                                  height: 80,

                                  child: Center(
                                    child: SvgPicture.asset(
                                      icons[index],
                                      fit: BoxFit.none,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                labels[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  onTap: (index) {
                    debugPrint("Tapped on ${labels[index]}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("You tapped ${labels[index]}")),
                    );
                  },
                ),
                AppSpacing.verticalSpaceMassive,
                const Text(
                  'Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                AppSpacing.verticalSpaceMedium,
                CustomHorizontalscroll(
                  itemCount: icons1.length,
                  itemBuilder: (index) {
                    final isSelected = selectedService.value == index;
                    Color imageColor = isSelected ? Colors.white : Colors.blue;
                    return SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                icons1[index],
                                colorFilter: ColorFilter.mode(
                                  imageColor,
                                  BlendMode.srcIn,
                                ),
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                          AppSpacing.verticalSpaceSmall,
                          Text(
                            labels1[index],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  onTap: (index) {
                    selectedService.value = index;
                  },
                ),

                AppSpacing.verticalSpaceMassive,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => debugPrint("Scheduled Payments tapped"),
                      child: const Text(
                        "Scheduled Payments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => debugPrint("See All tapped"),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),

                AppSpacing.verticalSpaceSmall,
                CustomVerticalscrolls(
                  itemCount: scheduledPayments.length,
                  itemBuilder: (index) {
                    final payments = scheduledPayments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                payments.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payments.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  payments.dueDate,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            payments.amount,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onTap: (index) {
                    final payment = scheduledPayments[index];
                    debugPrint("Tapped payment: ${payment.name}");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
