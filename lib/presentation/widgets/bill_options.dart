import 'package:esae_monie/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class BillOption extends HookWidget {
  final bool selected;
  final String image;
  final String label;
  final VoidCallback onTap;

  const BillOption({
    super.key,
    required this.selected,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : context.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/svgs/$image.svg', height: 24, width: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              activeColor: Colors.blue,
              shape: const CircleBorder(),
              side: BorderSide(
                color: selected ? Colors.blue : Colors.grey.shade400,
                width: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
