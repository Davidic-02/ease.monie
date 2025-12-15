import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/data/lists.dart';
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
              CustomTopbar(title: 'Amount'),
              AppSpacing.verticalSpaceMedium,
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
                  amount.value = parsed; // keep numeric value updated
                },
                onFieldSubmitted: (_) {
                  // Format only when user finishes typing
                  final parsed = amount.value;
                  controller.text = formatter.format(parsed);
                },
              ),

              AppSpacing.verticalSpaceMedium,
              Text('Quick Actions'),
              AppSpacing.verticalSpaceMedium,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: presetAmounts.map((amt) {
                  return GestureDetector(
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
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        formatter.format(amt),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Button('Next', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
