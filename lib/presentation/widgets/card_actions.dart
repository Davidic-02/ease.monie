import 'package:esae_monie/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class BuildActionButton extends HookWidget {
  final String image;
  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final bool useToggle;

  const BuildActionButton({
    super.key,
    required this.image,
    required this.label,
    this.color,
    this.onTap,
    required this.useToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isToggled = useState(false);
    return GestureDetector(
      onTap: useToggle ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(image),
            AppSpacing.horizontalSpaceHuge,
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            useToggle
                ? Switch(
                    value: isToggled.value,
                    onChanged: (value) {
                      isToggled.value = value;
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white54,
                  )
                : Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
