import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/formatter.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/recharge/recharge_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scrollbar.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';
import 'package:esae_monie/presentation/widgets/text_child.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Recharge extends HookWidget {
  static const String routeName = 'Recharge';
  Recharge({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final amountFocusNode = useFocusNode();
    final controller = useTextEditingController();
    final amount = useState<double>(0.0);
    final selectedIndex = useState<int?>(null);
    final TextEditingController numberController = useTextEditingController();
    final numberFocus = useFocusNode();
    final paymentOptionsFocus = useFocusNode();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomTopbar(
                title: 'Recharge',
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
                    TextTitle(text: 'Add Mobile Number'),
                    AppSpacing.verticalSpaceSmall,
                    TextChild(text: 'Enter receipent mobile Number'),

                    CustomTextFormField(
                      key: const ValueKey("recipient_number"),
                      controller: numberController,
                      focusNode: numberFocus,
                      hintText: "Recipient Mobile Number",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      errorText: numberController.text.isEmpty
                          ? "Mobile number required"
                          : null,
                      onFieldSubmitted: (_) =>
                          paymentOptionsFocus.requestFocus(),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    TextTitle(text: 'Select Network'),
                    AppSpacing.verticalSpaceMedium,
                    CustomHorizontalScrollbar(
                      itemCount: selectedNetwork.length,
                      itemBuilder: (index) {
                        final network = selectedNetwork[index];
                        final isSelected = selectedIndex.value == index;
                        final theme = Theme.of(context);

                        return GestureDetector(
                          onTap: () {
                            selectedIndex.value = index; // update selection
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width:
                                MediaQuery.of(context).size.width /
                                selectedNetwork.length,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? theme.dividerColor
                                    : theme.colorScheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            transform: Matrix4.identity()
                              ..scale(isSelected ? 1.05 : 1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    network.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.verticalSpaceMedium,
                                Text(
                                  network.name,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    TextTitle(text: 'Enter Amount'),

                    CustomTextFormField(
                      controller: controller,
                      focusNode: amountFocusNode,
                      hintText: 'Enter Amount',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) {
                        final clean = value.replaceAll(RegExp(r'[^0-9.]'), '');
                        final parsed = double.tryParse(clean) ?? 0.0;
                        amount.value = parsed;
                      },
                      onFieldSubmitted: (_) {
                        final parsed = amount.value;
                        controller.text = formatter.format(parsed);
                      },
                    ),
                    AppSpacing.verticalSpaceMassive,
                    TextTitle(text: 'Quick Actions'),
                    AppSpacing.verticalSpaceSmall,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: presetAmounts.map((amt) {
                          final isSelected = amount.value == amt;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                amount.value = amt;
                                controller.text = formatter.format(amt);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.blueColor
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: Text(
                                  formatter.format(amt),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Button(
                        color: AppColors.blueColor,
                        'Continue',
                        onPressed:
                            numberController.text.isEmpty ||
                                selectedIndex.value == null ||
                                amount.value <= 0
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  RechargeConfirmation.routeName,
                                  arguments: {
                                    'recipientNumber': numberController.text,
                                    'network':
                                        selectedNetwork[selectedIndex.value!],
                                    'amount': amount.value,
                                  },
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
  }
}
