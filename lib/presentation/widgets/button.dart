import 'dart:io';

import 'package:esae_monie/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Color textColor;
  final Color disabledTextColor;
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  final bool busy;
  final bool pill;
  final String? busyText;

  const Button(
    this.text, {
    super.key,
    this.onPressed,
    this.color,
    this.icon,
    this.iconColor,
    this.textColor = Colors.white,
    this.disabledTextColor = Colors.white,
    this.busy = false,
    this.pill = false,
    this.busyText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        maxWidth: double.infinity,
        minHeight: 52.0,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryColor;
            } else if (states.contains(WidgetState.disabled)) {
              return AppColors.darkSurface;
            }
            return color ?? AppColors.primaryColor;
          }),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(10),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(pill ? 40 : 10.0)),
            ),
          ),
        ),
        onPressed: onPressed,
        child: busy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      backgroundColor: Platform.isIOS ? Colors.white : null,
                    ),
                  ),
                  if (busyText != null)
                    Text(
                      "     $busyText",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              )
            : (icon == null
                  ? Text(
                      text!,
                      style: TextStyle(
                        color: onPressed == null
                            ? disabledTextColor
                            : textColor,
                        fontSize: 16.0,
                        fontFamily: "HelveticaRounded",
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Icon(icon, color: iconColor ?? Colors.black)),
      ),
    );
  }
}
