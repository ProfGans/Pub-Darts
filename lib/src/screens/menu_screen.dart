import 'package:flutter/material.dart';

import '../widgets/app_cards.dart';
import '../widgets/menu_button_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.onQuickMatch,
    required this.onCareer,
    required this.onTraining,
  });

  final VoidCallback onQuickMatch;
  final VoidCallback onCareer;
  final VoidCallback onTraining;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            lightPanel(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pub Darts',
                    style: TextStyle(
                      color: Color(0xFF75675A),
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hauptmenue',
                    style: TextStyle(
                      color: Color(0xFF1B130F),
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Die Flutter-Version startet jetzt mit einem klaren Hauptmenue und einer saubereren Mobile-Struktur.',
                    style: TextStyle(
                      color: Color(0xFF4A3D31),
                      fontSize: 16,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MenuButtonCard(
              title: 'Schnelles Spiel',
              subtitle: 'Direkt ins 501 Match mit Fadenkreuz und Zielkreis.',
              background: const Color(0xFFAF2B1C),
              titleColor: const Color(0xFFFFF8EE),
              subtitleColor: const Color(0xFFFFEFE2),
              onTap: onQuickMatch,
            ),
            const SizedBox(height: 14),
            MenuButtonCard(
              title: 'Karriere',
              subtitle: 'Spaeter fuer Turniere, Gegner, Ranglisten und Geld.',
              background: const Color(0xFFF5ECDE),
              titleColor: const Color(0xFF1B130F),
              subtitleColor: const Color(0xFF4A3D31),
              onTap: onCareer,
            ),
            const SizedBox(height: 14),
            MenuButtonCard(
              title: 'Training',
              subtitle: 'Spaeter fuer Bull-Training, Triple-Drills und Checkout-Uebungen.',
              background: const Color(0xFFF5ECDE),
              titleColor: const Color(0xFF1B130F),
              subtitleColor: const Color(0xFF4A3D31),
              onTap: onTraining,
            ),
          ],
        ),
      ),
    );
  }
}
