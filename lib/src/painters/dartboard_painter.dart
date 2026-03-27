import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/board_metrics.dart';

class DartboardPainter extends CustomPainter {
  const DartboardPainter({required this.numbers});

  final List<int> numbers;

  @override
  void paint(Canvas canvas, Size size) {
    final m = BoardMetrics.fromSize(size.width);
    canvas.drawCircle(
      Offset(m.center, m.center),
      m.outer * 1.1,
      Paint()..color = const Color(0xFF111111),
    );
    final borderPaint = Paint()
      ..color = const Color(0xFFDED3C0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006;

    for (var i = 0; i < numbers.length; i++) {
      final start = (-math.pi / 2) - (math.pi / 20) + (i * math.pi / 10);
      const sweep = math.pi / 10;
      final single = i.isEven ? const Color(0xFFF8F1E6) : const Color(0xFF121212);
      final ring = i.isEven ? const Color(0xFFF14839) : const Color(0xFF73BE5F);

      _paintWedge(canvas, m, 0, m.tripleInner, start, sweep, single);
      _paintWedge(canvas, m, m.tripleOuter, m.doubleInner, start, sweep, single);
      _paintWedge(canvas, m, m.tripleInner, m.tripleOuter, start, sweep, ring);
      _paintWedge(canvas, m, m.doubleInner, m.doubleOuter, start, sweep, ring);

      final labelAngle = start + sweep / 2;
      final labelPos = Offset(
        m.center + math.cos(labelAngle) * m.outer * 1.03,
        m.center + math.sin(labelAngle) * m.outer * 1.03,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${numbers[i]}',
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.055,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(labelPos.dx - tp.width / 2, labelPos.dy - tp.height / 2));
    }

    for (final r in [m.outer, m.doubleInner, m.doubleOuter, m.tripleInner, m.tripleOuter]) {
      canvas.drawCircle(Offset(m.center, m.center), r, borderPaint);
    }
    canvas.drawCircle(Offset(m.center, m.center), m.outerBull, Paint()..color = const Color(0xFF73BE5F));
    canvas.drawCircle(Offset(m.center, m.center), m.innerBull, Paint()..color = const Color(0xFFF14839));
  }

  void _paintWedge(
    Canvas canvas,
    BoardMetrics m,
    double inner,
    double outer,
    double start,
    double sweep,
    Color color,
  ) {
    final center = Offset(m.center, m.center);
    final outerRect = Rect.fromCircle(center: center, radius: outer);
    final path = Path();
    if (inner == 0) {
      path.moveTo(center.dx, center.dy);
      path.arcTo(outerRect, start, sweep, false);
      path.close();
    } else {
      final innerRect = Rect.fromCircle(center: center, radius: inner);
      path.arcTo(outerRect, start, sweep, false);
      path.arcTo(innerRect, start + sweep, -sweep, false);
      path.close();
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant DartboardPainter oldDelegate) =>
      oldDelegate.numbers != numbers;
}
