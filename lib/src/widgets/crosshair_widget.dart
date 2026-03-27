import 'package:flutter/material.dart';

class CrosshairWidget extends StatelessWidget {
  const CrosshairWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 36, height: 2, color: const Color(0xFFFFF7DB)),
          Container(width: 2, height: 36, color: const Color(0xFFFFF7DB)),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5137),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.92),
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
