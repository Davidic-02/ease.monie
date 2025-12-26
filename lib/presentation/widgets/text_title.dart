import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  final Color? color;

  const TextTitle({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: color ?? Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }
}
