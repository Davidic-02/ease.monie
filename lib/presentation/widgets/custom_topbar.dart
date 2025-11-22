import 'package:flutter/material.dart';

class CustomTopbar extends StatelessWidget {
  final String title;
  final Widget leading;
  final String? ending;
  final VoidCallback? onTap;

  CustomTopbar({
    super.key,
    required this.title,
    Widget? leading,
    this.ending,
    this.onTap,
  }) : leading = GestureDetector(
         onTap: onTap,
         child: Container(
           width: 48,
           height: 48,
           decoration: BoxDecoration(
             color: Colors.grey.shade300,
             shape: BoxShape.circle,
           ),
           child: const Icon(
             Icons.arrow_back_ios_new,
             color: Colors.black38,
             size: 22,
           ),
         ),
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading,
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.black38,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
