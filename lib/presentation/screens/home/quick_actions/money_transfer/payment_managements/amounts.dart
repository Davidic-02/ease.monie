import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/screens/home/quick_actions/payment_managements/confirmation.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class Amount extends HookWidget {
  const Amount({super.key});
  static const String routeName = 'Amount';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final accountName = args['accountName'];
    final bankName = args['bankName'];
    final accountNumber = args['accountNumber'];
    final amountFocusNode = useFocusNode();
    final controller = useTextEditingController();
    final amount = useState<double>(0.0);
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
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
              Text('Enter Amount'),
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
              AppSpacing.verticalSpaceHuge,
              Text('Quick Actions'),
              AppSpacing.verticalSpaceSmall,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: presetAmounts.map((amt) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ), // spacing between buttons
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
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer, // theme-aware color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formatter.format(amt),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color, // theme-aware text
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
              Button(
                'Next',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Confirmation.routeName,
                    arguments: {
                      'accountName': accountName,
                      'bankName': bankName,
                      'accountNumber': accountNumber,
                      'amount': amount.value,
                    },
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
