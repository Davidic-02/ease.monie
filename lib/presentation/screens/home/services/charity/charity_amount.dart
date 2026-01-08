import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/services_model.dart';
import 'package:esae_monie/presentation/data/formatter.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/services/charity/charity_confirmation.dart';

import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CharityAmount extends HookWidget {
  const CharityAmount({super.key});
  static const String routeName = 'CharityAmount';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final charity = args['charity'] as ServicesModel;
    final accountName = args['accountName'];
    final bankName = args['bankName'];
    final accountNumber = args['accountNumber'];
    final amountFocusNode = useFocusNode();
    final controller = useTextEditingController();
    final amount = useState<double>(0.0);

    double screenHeight = MediaQuery.of(context).size.height;

    useEffect(() {
      amountFocusNode.requestFocus();
      return null;
    }, const []);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopbar(
                title: 'Amount',
                onTap: () {
                  Navigator.pop(context);
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
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blueColor.shade300,
                ),
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
              SizedBox(height: screenHeight * 0.3),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: Button(
                  'Next',
                  color: AppColors.blueColor,
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      CharityConfirmation.routeName,
                      arguments: {
                        'charity': charity,
                        'accountName': accountName,
                        'bankName': bankName,
                        'accountNumber': accountNumber,
                        'amount': amount.value,
                        'imagePath': args['imagePath'],
                        'title': args['title'],
                      },
                    );

                    if (result != null) {
                      Navigator.pop(context, result);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
