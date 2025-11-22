import 'package:esae_monie/blocs/user/user_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontalscroll.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontalscrollbar.dart';
import 'package:esae_monie/presentation/widgets/custom_verticalscrolls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .2),
                CustomTopbar(
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/profilepic.png'),
                  ),
                  title: 'FIntech',
                ),
                AppSpacing.verticalSpaceMedium,
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/fourth.png',
                                  width: 340,
                                  height: 215,
                                  fit: BoxFit.cover,
                                ),

                                if (index == 0)
                                  Positioned(
                                    left: 16,
                                    top: 16,
                                    child: BlocBuilder<UserBloc, UserState>(
                                      builder: (context, state) {
                                        if (state.isLoading) {
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
                                            const Text(
                                              'Card Holder',
                                              style: TextStyle(
                                                color: AppColors.lighterWhite,
                                                fontSize: 12,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 4,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AppSpacing.verticalSpaceSmall,
                                            Text(
                                              user.name,
                                              style: const TextStyle(
                                                color: AppColors.lighterWhite,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 4,
                                                    color: Colors.black,
                                                  ),
                                                ],
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
                          ),
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
                        width: 130,
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: colors[index],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                icons[index],
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 12),
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
                    return Container(
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
                                  : AppColors.greyColor,
                            ),
                            child: Center(
                              child: Icon(
                                icons1[index],
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          AppSpacing.verticalSpaceSmall,
                          Text(
                            labels1[index],
                            style: const TextStyle(fontSize: 12),
                            textAlign:
                                TextAlign.center, // ADDED: Center alignment
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
