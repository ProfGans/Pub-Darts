import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/stat_type.dart';
import '../painters/dartboard_painter.dart';
import '../widgets/app_cards.dart';
import '../widgets/attribute_control_card.dart';
import '../widgets/crosshair_widget.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({
    super.key,
    required this.boardSize,
    required this.boardNumbers,
    required this.radius,
    required this.crosshair,
    required this.fingerLocal,
    required this.landing,
    required this.hint,
    required this.lastThrow,
    required this.remaining,
    required this.dartsLeft,
    required this.roundPoints,
    required this.roundLog,
    required this.rankLabel,
    required this.skillPoints,
    required this.precision,
    required this.calm,
    required this.consistency,
    required this.onBack,
    required this.onReset,
    required this.onAdjustStat,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onPanCancel,
  });

  final double boardSize;
  final List<int> boardNumbers;
  final double radius;
  final Offset crosshair;
  final Offset? fingerLocal;
  final Offset? landing;
  final String hint;
  final String lastThrow;
  final int remaining;
  final int dartsLeft;
  final int roundPoints;
  final String roundLog;
  final String rankLabel;
  final int skillPoints;
  final int precision;
  final int calm;
  final int consistency;
  final VoidCallback onBack;
  final VoidCallback onReset;
  final void Function(StatType type, int delta) onAdjustStat;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final VoidCallback onPanCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 430;
            final effectiveBoardSize = math.min(boardSize, constraints.maxWidth - 8);
            final point = crosshair * effectiveBoardSize;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      FilledButton(
                        onPressed: onBack,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF5ECDE),
                          foregroundColor: const Color(0xFF1B130F),
                        ),
                        child: const Text('Menue'),
                      ),
                      const Spacer(),
                      Text(
                        'Match',
                        style: TextStyle(
                          fontSize: compact ? 20 : 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (compact) ...[
                    InfoCard(label: 'Letzter Wurf', value: lastThrow, compact: true),
                    const SizedBox(height: 10),
                    InfoCard(label: 'Rest 501', value: '$remaining', compact: true),
                    const SizedBox(height: 10),
                    InfoCard(label: 'Darts frei', value: '$dartsLeft', compact: true),
                  ] else
                    Row(
                      children: [
                        Expanded(child: InfoCard(label: 'Letzter Wurf', value: lastThrow)),
                        const SizedBox(width: 10),
                        Expanded(child: InfoCard(label: 'Rest 501', value: '$remaining')),
                        const SizedBox(width: 10),
                        Expanded(child: InfoCard(label: 'Darts frei', value: '$dartsLeft')),
                      ],
                    ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: onPanStart,
                    onPanUpdate: onPanUpdate,
                    onPanEnd: onPanEnd,
                    onPanCancel: onPanCancel,
                    child: Container(
                      width: effectiveBoardSize,
                      height: effectiveBoardSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE4D1),
                        borderRadius: BorderRadius.circular(compact ? 24 : 28),
                        border: Border.all(color: const Color(0xFFD4B185), width: 4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(compact ? 20 : 24),
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: Size.square(effectiveBoardSize),
                              painter: DartboardPainter(numbers: boardNumbers),
                            ),
                            Positioned(
                              left: point.dx - radius,
                              top: point.dy - radius,
                              child: IgnorePointer(
                                child: Container(
                                  width: radius * 2,
                                  height: radius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFF5436),
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: point.dx - 18,
                              top: point.dy - 18,
                              child: const IgnorePointer(child: CrosshairWidget()),
                            ),
                            if (fingerLocal != null)
                              Positioned(
                                left: fingerLocal!.dx - 14,
                                top: fingerLocal!.dy - 14,
                                child: IgnorePointer(
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.18),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.42),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (landing != null)
                              Positioned(
                                left: landing!.dx - 7,
                                top: landing!.dy - 7,
                                child: IgnorePointer(
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFFFD978),
                                      border: Border.all(
                                        color: const Color(0xFFFFF5CF),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              left: 12,
                              right: 12,
                              bottom: 12,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xD6180E09),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    hint,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFFFFF8EE),
                                      fontSize: compact ? 12 : 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (compact) ...[
                    DetailCard(title: 'Runde', value: '$roundPoints Punkte', text: roundLog),
                    const SizedBox(height: 10),
                    DetailCard(
                      title: 'Spieler',
                      value: rankLabel,
                      text: 'Talentpunkte: $skillPoints',
                    ),
                  ] else
                    Row(
                      children: [
                        Expanded(
                          child: DetailCard(
                            title: 'Runde',
                            value: '$roundPoints Punkte',
                            text: roundLog,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DetailCard(
                            title: 'Spieler',
                            value: rankLabel,
                            text: 'Talentpunkte: $skillPoints',
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  AttributeControlCard(
                    label: 'Praezision',
                    value: precision,
                    onMinus: () => onAdjustStat(StatType.precision, -4),
                    onPlus: () => onAdjustStat(StatType.precision, 4),
                  ),
                  const SizedBox(height: 8),
                  AttributeControlCard(
                    label: 'Ruhe',
                    value: calm,
                    onMinus: () => onAdjustStat(StatType.calm, -4),
                    onPlus: () => onAdjustStat(StatType.calm, 4),
                  ),
                  const SizedBox(height: 8),
                  AttributeControlCard(
                    label: 'Konstanz',
                    value: consistency,
                    onMinus: () => onAdjustStat(StatType.consistency, -4),
                    onPlus: () => onAdjustStat(StatType.consistency, 4),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onReset,
                      child: const Text('Match neu starten'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
