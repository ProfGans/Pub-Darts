import 'package:flutter/material.dart';

class AttributeControlCard extends StatelessWidget {
  const AttributeControlCard({
    super.key,
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5ECDE),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1B130F),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _RoundButton(symbol: '-', onTap: onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$value',
                style: const TextStyle(
                  color: Color(0xFF1B130F),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          _RoundButton(symbol: '+', onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.symbol, required this.onTap});

  final String symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Ink(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xFFAF2B1C),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            symbol,
            style: const TextStyle(
              color: Color(0xFFFFF8EE),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
