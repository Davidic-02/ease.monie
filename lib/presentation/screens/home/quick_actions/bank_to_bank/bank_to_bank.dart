import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/data/lists.dart';
import 'package:esae_monie/presentation/widgets/custom_horizontal_scroll.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BankToBank extends HookWidget {
  const BankToBank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopbar(
                title: 'Money Transfer',
                onTap: () => Navigator.pop(context),
              ),
              AppSpacing.verticalSpaceHuge,
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: context.theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  debugPrint("Searching for: $value");
                },
              ),
              AppSpacing.verticalSpaceMassive,
              Text(
                'Bank',
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  //  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              AppSpacing.verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}
