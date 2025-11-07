import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    this.controller,
    required this.focusNode,
    required this.hintText,
    required this.keyboardType,
    this.customFilled,
    this.title,
    super.key,
    this.obscureText = false,
    this.isPassword = false,
    this.isFilled = true,
    this.readOnly = false,
    this.validator,
    this.textInputAction,
    this.onSuffixIconPressed,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.maxLength,
    this.fillColor,
    this.editIcon,
    this.onChanged,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode focusNode;
  final String? title;
  final String hintText;
  final Color? fillColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? prefixIcon;
  final Widget? editIcon;
  final bool isPassword;
  final bool isFilled;
  final bool readOnly;
  final bool? customFilled;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function()? onSuffixIconPressed;
  final void Function()? onFieldSubmitted;
  final void Function()? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        AppSpacing.verticalSpaceSmall,
        TextFormField(
          cursorColor: AppColors.primaryColor,
          maxLength: maxLength,
          onEditingComplete: onFieldSubmitted,
          onChanged: onChanged,
          readOnly: readOnly,
          style: Theme.of(context).textTheme.bodyMedium,
          focusNode: focusNode,
          textInputAction: textInputAction,
          controller: controller,
          keyboardType: keyboardType,
          onTap: onTap,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            fillColor:
                fillColor ??
                (customFilled ?? true
                    ? AppColors.greyColor.withValues(alpha: .1)
                    : null),
            filled: isFilled,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              color: AppColors.greyColor,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: prefixIcon == null
                  ? null
                  : SvgPicture.asset(
                      'assets/svg/$prefixIcon.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.greyColor,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
            suffixIcon: customFilled ?? false
                ? Padding(padding: const EdgeInsets.all(13), child: editIcon)
                : isPassword
                ? IconButton(
                    onPressed: onSuffixIconPressed,
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.greyColor,
                    ),
                  )
                : null,
          ),
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }
}
