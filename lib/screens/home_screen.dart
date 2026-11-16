import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/game_button.dart';
import 'game_screen.dart';
import 'character_screen.dart';
import 'achievement_screen.dart';
import 'settings_screen.dart';
import 'high_score_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService.instance;

  Future<void> _refresh() async => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Color(0xFFFFD54F),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_storage.coins}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'SKYRUSH',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dodge. Fly. Survive.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              GameButton(
                label: 'PLAY',
                icon: Icons.play_arrow,
                colors: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
                onPressed: () async {
                  await Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const GameScreen()));
                  _refresh();
                },
              ),
              const SizedBox(height: 16),
              GameButton(
                label: 'Characters',
                icon: Icons.emoji_people,
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CharacterScreen()),
                  );
                  _refresh();
                },
              ),
              const SizedBox(height: 16),
              GameButton(
                label: 'Achievements',
                icon: Icons.emoji_events,
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AchievementScreen(),
                    ),
                  );
                  _refresh();
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameButton(
                    label: 'High Score',
                    icon: Icons.leaderboard,
                    width: 160,
                    colors: const [Color(0xFFFF7043), Color(0xFFFFB300)],
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HighScoreScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  GameButton(
                    label: 'Settings',
                    icon: Icons.settings,
                    width: 160,
                    colors: const [Color(0xFF757F9A), Color(0xFFD7DDE8)],
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                      _refresh();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
