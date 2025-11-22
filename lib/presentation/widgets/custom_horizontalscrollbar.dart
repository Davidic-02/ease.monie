import 'package:flutter/material.dart';

class CustomHorizontalScrollbar extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final void Function(int index)? onTap;

  const CustomHorizontalScrollbar({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 10),
            child: InkWell(
              onTap: onTap != null ? () => onTap!(index) : null,
              borderRadius: BorderRadius.circular(12),
              child: itemBuilder(index),
            ),
          );
        }),
      ),
    );
  }
}
