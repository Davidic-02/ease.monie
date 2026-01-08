import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/insurance_model.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/insurance/insurance_confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InsuranceInfomation extends HookWidget {
  static const String routeName = 'InsuranceInformation';
  const InsuranceInfomation({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState<String?>(null);

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final ServicesModel services = args['service'];
    final InsuranceModel selectedInsurance = args['insurance'];
    final cardNameController = useTextEditingController();
    final cardNumberController = useTextEditingController();
    final expiryController = useTextEditingController();
    final cvvController = useTextEditingController();

    final cardNameFocus = useFocusNode();
    final cardNumberFocus = useFocusNode();
    final expiryFocus = useFocusNode();
    final cvvFocus = useFocusNode();

    final nameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final familyMembersController = useTextEditingController();
    final paymentDetailsController = useTextEditingController();
    final purposeController = useTextEditingController();
    final paymentOptionsController = useTextEditingController();

    final nameFocus = useFocusNode();
    final lastNameFocus = useFocusNode();
    final familyFocus = useFocusNode();
    final paymentDetailsFocus = useFocusNode();
    final purposeFocus = useFocusNode();
    final paymentOptionsFocus = useFocusNode();

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
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                services.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            AppSpacing.verticalSpaceMedium,
                            Text(
                              services.title,
                              style: Theme.of(context).textTheme.titleMedium,
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
                    TextTitle(text: 'Add Information'),
                    CustomTextFormField(
                      key: const ValueKey("name"),
                      focusNode: nameFocus,
                      hintText: "Name",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => nameController.text = value,
                      errorText: nameController.text.isEmpty
                          ? "Name is required"
                          : null,
                      onFieldSubmitted: (_) => lastNameFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("lastName"),
                      focusNode: lastNameFocus,
                      hintText: "Last Name",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => lastNameController.text = value,
                      errorText: lastNameController.text.isEmpty
                          ? "Last Name is required"
                          : null,
                      onFieldSubmitted: (_) => familyFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("family"),
                      focusNode: familyFocus,
                      hintText: "Total Family Members",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          familyMembersController.text = value,
                      errorText: familyMembersController.text.isEmpty
                          ? "Total is required"
                          : null,
                      onFieldSubmitted: (_) =>
                          paymentDetailsFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("paymentDetails"),
                      focusNode: paymentDetailsFocus,
                      hintText: "Payment Details",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          paymentDetailsController.text = value,
                      errorText: paymentDetailsController.text.isEmpty
                          ? "Payment details required"
                          : null,
                      onFieldSubmitted: (_) => purposeFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("purpose"),
                      focusNode: purposeFocus,
                      hintText: "Purpose of Payment",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => purposeController.text = value,
                      errorText: purposeController.text.isEmpty
                          ? "Purpose required"
                          : null,
                      onFieldSubmitted: (_) =>
                          paymentOptionsFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("paymentOptions"),
                      focusNode: paymentOptionsFocus,
                      hintText: "Payment Options",
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      onChanged: (value) =>
                          paymentOptionsController.text = value,
                      errorText: paymentOptionsController.text.isEmpty
                          ? "Payment option required"
                          : null,
                    ),
                    AppSpacing.verticalSpaceMassive,
                    TextTitle(text: 'Add Account Details'),
                    CustomTextFormField(
                      key: const ValueKey("cardName"),
                      focusNode: cardNameFocus,
                      hintText: "Card Holder Name",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => cardNameController.text = value,
                      errorText: cardNameController.text.isEmpty
                          ? "Card name required"
                          : null,
                      onFieldSubmitted: (_) => cardNumberFocus.requestFocus(),
                    ),

                    CustomTextFormField(
                      key: const ValueKey("cardNumber"),
                      focusNode: cardNumberFocus,
                      hintText: "Card Number",
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => cardNumberController.text = value,
                      errorText: cardNumberController.text.isEmpty
                          ? "Card number required"
                          : null,
                      onFieldSubmitted: (_) => expiryFocus.requestFocus(),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            key: const ValueKey("expiry"),
                            focusNode: expiryFocus,
                            hintText: "MM/YY",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => expiryController.text = value,
                            errorText: expiryController.text.isEmpty
                                ? "Required"
                                : null,
                            onFieldSubmitted: (_) => cvvFocus.requestFocus(),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            key: const ValueKey("cvv"),
                            focusNode: cvvFocus,
                            hintText: "CVV",
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => cvvController.text = value,
                            errorText: cvvController.text.isEmpty
                                ? "Required"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalSpaceMassive,
                    TextTitle(text: 'Payment Plan'),

                    AppSpacing.verticalSpaceMedium,

                    Row(
                      children: paymentPlan.map((plan) {
                        final isSelected = selectedPlan.value == plan;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => selectedPlan.value = plan,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.blueColor
                                    : Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                plan,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    AppSpacing.verticalSpaceHuge,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Button(
                        color: AppColors.blueColor,
                        'Continue',
                        onPressed: selectedPlan.value == null
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  InsuranceConfirmation.routeName,
                                  arguments: {
                                    'service': services,
                                    'insurance': selectedInsurance,
                                    'paymentPlan': selectedPlan.value,
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
