import 'package:flutter/material.dart';

class CustomHorizontalscroll extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final void Function(int index)? onTap;

  const CustomHorizontalscroll({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return RawScrollbar(
      thumbVisibility: true,
      thickness: 4.0,
      radius: const Radius.circular(2.0),
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(itemCount, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == itemCount - 1 ? 0 : 10,
                ),

                child: InkWell(
                  onTap: onTap != null ? () => onTap!(index) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: itemBuilder(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
