import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class TypeOfGift extends HookWidget {
  static const String routeName = 'TypeOfGift';
  const TypeOfGift({super.key});

  @override
  Widget build(BuildContext context) {
    final giftMessageController = useTextEditingController();
    final giftMessageFocus = useFocusNode();
    final nameController = TextEditingController();
    final accountController = TextEditingController();
    final purposeController = TextEditingController();
    final passwordController = TextEditingController();
    final nameFocus = useFocusNode();
    final accountFocus = useFocusNode();
    final purposeFocus = useFocusNode();
    final passwordFocus = useFocusNode();
    final amountFocusNode = useFocusNode();
    final controller = useTextEditingController();
    final amount = useState<double>(0.0);
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );

    final services =
        ModalRoute.of(context)!.settings.arguments as ServicesModel;
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
                                services.imagePath,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppSpacing.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(services.title)],
                            ),
                            Text(
                              services.organizer,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.verticalSpaceMassive,
                    Text(
                      'Add Receipient Bank Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueColor.shade300,
                      ),
                    ),
                    AppSpacing.verticalSpaceMedium,

                    CustomTextFormField(
                      key: const ValueKey("name"),
                      focusNode: nameFocus,
                      hintText: "Name",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      fillColor: AppColors.whiteColor,

                      onChanged: (value) {
                        nameController.text = value;
                      },

                      errorText: nameController.text.isEmpty
                          ? "Name is required"
                          : null,

                      onFieldSubmitted: (_) => accountFocus.requestFocus(),
                    ),

                    AppSpacing.verticalSpaceMedium,

                    CustomTextFormField(
                      key: const ValueKey("account"),
                      focusNode: accountFocus,
                      hintText: "Account Number",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      fillColor: AppColors.whiteColor,
                      controller: accountController,
                      onChanged: (value) {
                        accountController.text = value;
                      },
                      errorText: accountController.text.isEmpty
                          ? "Account number is required"
                          : null,
                      onFieldSubmitted: (_) => purposeFocus.requestFocus(),
                    ),

                    AppSpacing.verticalSpaceMedium,

                    CustomTextFormField(
                      key: const ValueKey("purpose"),
                      focusNode: purposeFocus,
                      hintText: "Purpose",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      fillColor: AppColors.whiteColor,
                      controller: purposeController,
                      onChanged: (value) {
                        purposeController.text = value;
                      },
                      errorText: purposeController.text.isEmpty
                          ? "Purpose is required"
                          : null,
                      onFieldSubmitted: (_) => passwordFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("password"),
                      focusNode: passwordFocus,
                      hintText: "Password",
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true, // hide password
                      fillColor: AppColors.whiteColor,
                      controller: passwordController,
                      onChanged: (value) {
                        passwordController.text = value;
                      },
                      errorText: passwordController.text.isEmpty
                          ? "Password is required"
                          : null,
                      onFieldSubmitted: (_) {
                        passwordFocus.unfocus(); // hide keyboard
                        // optionally call submit function here
                      },
                    ),
                    AppSpacing.verticalSpaceMassive,
                    Text(
                      'Enter Amount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueColor.shade300,
                      ),
                    ),

                    AppSpacing.verticalSpaceMedium,

                    CustomTextFormField(
                      controller: controller,
                      focusNode: amountFocusNode,
                      hintText: 'EnterAmount',
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

                    Text(
                      'Enter Gift Message',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueColor.shade300,
                      ),
                    ),

                    AppSpacing.verticalSpaceSmall,
                    CustomTextFormField(
                      key: const ValueKey("gift_message"),
                      controller: giftMessageController,
                      focusNode: giftMessageFocus,
                      hintText: "Write your gift message here...",
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      fillColor: AppColors.whiteColor,

                      minLines: 4,
                      maxLines: 6,

                      onChanged: (value) {
                        giftMessageController.text = value;
                      },

                      errorText: giftMessageController.text.isEmpty
                          ? "Gift message cannot be empty"
                          : null,
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
