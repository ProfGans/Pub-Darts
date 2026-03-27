import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/app_screen.dart';
import 'models/board_metrics.dart';
import 'models/stat_type.dart';
import 'models/throw_result.dart';
import 'screens/match_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/placeholder_screen.dart';

class PubDartsApp extends StatelessWidget {
  const PubDartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Darts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF24180F),
      ),
      home: const PubDartsHome(),
    );
  }
}

class PubDartsHome extends StatefulWidget {
  const PubDartsHome({super.key});

  @override
  State<PubDartsHome> createState() => _PubDartsHomeState();
}

class _PubDartsHomeState extends State<PubDartsHome>
    with SingleTickerProviderStateMixin {
  static const boardNumbers = <int>[
    20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5,
  ];

  final random = math.Random();
  late final AnimationController controller;

  AppScreen screen = AppScreen.menu;
  int precision = 38;
  int calm = 26;
  int consistency = 31;
  int remaining = 501;
  int dartsUsed = 0;
  int turnPoints = 0;
  int skillPoints = 3;
  int wins = 0;
  List<String> turnThrows = <String>[];
  String lastThrow = 'Noch keiner';
  String hint = 'Tippe im Spielbereich. Loslassen wirft sofort.';

  double boardSize = 320;
  double radius = 0;
  bool isAiming = false;
  bool aimCancelled = false;
  Offset crosshair = const Offset(0.5, 0.5);
  Offset? dragOffset;
  Offset? fingerLocal;
  Offset? landing;

  double get maxRadius => boardSize * (0.17 - (precision / 100) * 0.045);
  double get minRadius => boardSize * (0.03 - (precision / 100) * 0.012);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )
      ..addListener(_updateRadius)
      ..addStatusListener((status) {
        if (!isAiming) return;
        if (status == AnimationStatus.completed) controller.reverse();
        if (status == AnimationStatus.dismissed) controller.forward();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _updateRadius() {
    if (!isAiming) return;
    final shrinking = controller.status != AnimationStatus.reverse;
    final eased = shrinking
        ? Curves.easeInExpo.transform(controller.value)
        : Curves.easeOutExpo.transform(1 - controller.value);
    setState(() => radius = lerpDouble(maxRadius, minRadius, eased)!);
  }

  void resetMatch() {
    controller.stop();
    controller.value = 0;
    setState(() {
      crosshair = const Offset(0.5, 0.5);
      dragOffset = null;
      fingerLocal = null;
      landing = null;
      radius = 0;
      remaining = 501;
      dartsUsed = 0;
      turnPoints = 0;
      turnThrows = <String>[];
      lastThrow = 'Noch keiner';
      hint = 'Neues 501-Spiel gestartet.';
      isAiming = false;
      aimCancelled = false;
    });
  }

  void startAim(DragStartDetails details) {
    final local = details.localPosition;
    if (!_insideBoard(local)) return;
    final point = crosshair * boardSize;
    dragOffset = point - local;
    fingerLocal = local;
    landing = null;
    aimCancelled = false;
    _moveCrosshair(local);
    isAiming = true;
    radius = maxRadius;
    hint = 'Halte kurz. Der Kreis schrumpft schnell und oeffnet sich wieder.';
    controller
      ..duration =
          Duration(milliseconds: 300 + (((100 - calm) / 100) * 220).round())
      ..reset()
      ..forward();
    setState(() {});
  }

  void updateAim(DragUpdateDetails details) {
    if (!isAiming) return;
    final local = details.localPosition;
    fingerLocal = local;
    if (!_insideBoard(local)) {
      setState(() {
        aimCancelled = true;
        hint = 'Kein Wurf, wenn du ausserhalb loslaesst.';
      });
      return;
    }
    aimCancelled = false;
    _moveCrosshair(local);
    setState(() {});
  }

  void endAim(DragEndDetails details) {
    if (!isAiming) return;
    controller.stop();
    if (aimCancelled) {
      setState(() {
        isAiming = false;
        fingerLocal = null;
        hint = 'Kein Wurf gezaehlt. Du hast den Spielbereich verlassen.';
      });
      return;
    }

    final hit = _randomPoint(crosshair * boardSize, radius, consistency / 100);
    final result = _evaluate(hit);
    final projected = remaining - result.value;
    final bust = projected < 0;
    final nextDarts = dartsUsed + 1;

    setState(() {
      landing = hit;
      fingerLocal = null;
      isAiming = false;
      dartsUsed = nextDarts;
      turnThrows = [...turnThrows, result.label];
      lastThrow =
          bust ? '${result.label} (Bust)' : '${result.label} (${result.value})';
    });

    if (bust) {
      _nextTurn('Bust. Runde endet ohne Punkte.');
      return;
    }

    setState(() {
      remaining = projected;
      turnPoints += result.value;
    });

    if (remaining == 0) {
      setState(() {
        wins += 1;
        skillPoints += 2;
        hint = 'Leg gewonnen. Du bekommst 2 Talentpunkte.';
      });
      return;
    }

    if (nextDarts >= 3) {
      _nextTurn('Neue Runde. Ziele den ersten Dart.');
      return;
    }

    setState(() => hint = 'Naechster Dart: wieder ziehen und loslassen.');
  }

  void cancelAim() {
    controller.stop();
    setState(() {
      isAiming = false;
      fingerLocal = null;
      aimCancelled = false;
    });
  }

  void _nextTurn(String message) {
    setState(() {
      dartsUsed = 0;
      turnPoints = 0;
      turnThrows = <String>[];
      hint = message;
      fingerLocal = null;
      isAiming = false;
    });
  }

  bool _insideBoard(Offset local) =>
      local.dx >= 0 &&
      local.dx <= boardSize &&
      local.dy >= 0 &&
      local.dy <= boardSize;

  void _moveCrosshair(Offset local) {
    final next = local + (dragOffset ?? Offset.zero);
    final clamped = Offset(
      next.dx.clamp(24, boardSize - 24),
      next.dy.clamp(24, boardSize - 24),
    );
    crosshair = Offset(clamped.dx / boardSize, clamped.dy / boardSize);
  }

  ThrowResult _evaluate(Offset point) {
    final m = BoardMetrics.fromSize(boardSize);
    final dx = point.dx - m.center;
    final dy = point.dy - m.center;
    final distance = math.sqrt(dx * dx + dy * dy);

    if (distance > m.outer) return const ThrowResult('Miss', 0);
    if (distance <= m.innerBull) return const ThrowResult('Inner Bull', 50);
    if (distance <= m.outerBull) return const ThrowResult('Outer Bull', 25);

    final rawAngle = math.atan2(dy, dx);
    final normalized =
        (rawAngle + (math.pi / 2) + (math.pi / 20) + (math.pi * 2)) %
            (math.pi * 2);
    final index = (normalized / (math.pi / 10)).floor() % 20;
    final base = boardNumbers[index];

    if (distance >= m.doubleInner && distance <= m.doubleOuter) {
      return ThrowResult('Double $base', base * 2);
    }
    if (distance >= m.tripleInner && distance <= m.tripleOuter) {
      return ThrowResult('Triple $base', base * 3);
    }
    return ThrowResult('Single $base', base);
  }

  Offset _randomPoint(Offset center, double circleRadius, double consistencyValue) {
    final angle = random.nextDouble() * math.pi * 2;
    final spread = (1 - consistencyValue) * math.sqrt(random.nextDouble()) +
        consistencyValue * random.nextDouble() * 0.55;
    return Offset(
      center.dx + math.cos(angle) * circleRadius * spread,
      center.dy + math.sin(angle) * circleRadius * spread,
    );
  }

  String _rankLabel() {
    if (wins >= 6) return 'Regionaler Herausforderer';
    if (wins >= 3) return 'Liga-Aufsteiger';
    return 'Kneipenliga Rookie';
  }

  @override
  Widget build(BuildContext context) {
    boardSize = math.min(MediaQuery.of(context).size.width - 32, 360);

    return switch (screen) {
      AppScreen.menu => MenuScreen(
          onQuickMatch: () {
            resetMatch();
            setState(() => screen = AppScreen.match);
          },
          onCareer: () => setState(() => screen = AppScreen.career),
          onTraining: () => setState(() => screen = AppScreen.training),
        ),
      AppScreen.career => PlaceholderScreen(
          title: 'Karriere',
          message:
              'Aktueller Rang: ${_rankLabel()}. Talentpunkte: $skillPoints. Hier bauen wir spaeter Turniere, Gegner und Progression ein.',
          onBack: () => setState(() => screen = AppScreen.menu),
        ),
      AppScreen.training => PlaceholderScreen(
          title: 'Training',
          message:
              'Hier kommen spaeter Bull-Training, Triple-Drills und Checkout-Uebungen hinein.',
          onBack: () => setState(() => screen = AppScreen.menu),
        ),
      AppScreen.match => MatchScreen(
          boardSize: boardSize,
          boardNumbers: boardNumbers,
          radius: radius,
          crosshair: crosshair,
          fingerLocal: fingerLocal,
          landing: landing,
          hint: hint,
          lastThrow: lastThrow,
          remaining: remaining,
          dartsLeft: 3 - dartsUsed,
          roundPoints: turnPoints,
          roundLog: turnThrows.isEmpty
              ? 'Wuerfe erscheinen hier.'
              : turnThrows.join(' | '),
          rankLabel: _rankLabel(),
          skillPoints: skillPoints,
          precision: precision,
          calm: calm,
          consistency: consistency,
          onBack: () => setState(() => screen = AppScreen.menu),
          onReset: resetMatch,
          onAdjustStat: (type, delta) => setState(() {
            if (type == StatType.precision) {
              precision = (precision + delta).clamp(0, 100);
            }
            if (type == StatType.calm) {
              calm = (calm + delta).clamp(0, 100);
            }
            if (type == StatType.consistency) {
              consistency = (consistency + delta).clamp(0, 100);
            }
          }),
          onPanStart: startAim,
          onPanUpdate: updateAim,
          onPanEnd: endAim,
          onPanCancel: cancelAim,
        ),
    };
  }
}
