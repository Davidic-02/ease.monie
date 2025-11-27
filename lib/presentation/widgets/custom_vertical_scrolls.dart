import 'package:flutter/material.dart';

class CustomVerticalscrolls extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final void Function(int index)? onTap;
  final double? height;

  const CustomVerticalscrolls({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 250,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 0),
            child: InkWell(
              onTap: onTap != null ? () => onTap!(index) : null,
              borderRadius: BorderRadius.circular(12),
              child: itemBuilder(index),
            ),
          );
        },
      ),
    );
  }
}
