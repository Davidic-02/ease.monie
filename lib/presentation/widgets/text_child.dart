import 'package:flutter/material.dart';

class TextChild extends StatelessWidget {
  final String text;

  const TextChild({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
