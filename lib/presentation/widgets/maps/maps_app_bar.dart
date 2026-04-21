import 'package:flutter/material.dart';
import 'package:esae_monie/presentation/widgets/custom_topBar.dart';

class MapAppBar extends StatelessWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: CustomTopbar(title: 'ATM Locator'),
        ),
      ),
    );
  }
}
