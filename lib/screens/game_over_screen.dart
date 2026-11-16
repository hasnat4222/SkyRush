import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../widgets/game_button.dart';
import 'game_screen.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final int bestScore;
  final int coinsCollected;
  final int survivalSeconds;
  final bool isNewHighScore;
  final List<AchievementModel> newlyUnlockedAchievements;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.bestScore,
    required this.coinsCollected,
    required this.survivalSeconds,
    required this.isNewHighScore,
    required this.newlyUnlockedAchievements,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'GAME OVER',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    if (widget.isNewHighScore) ...[
                      const SizedBox(height: 10),
                      const Text(
                        '🎉 NEW HIGH SCORE! 🎉',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD54F),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _statRow('Score', '${widget.score}'),
                    _statRow('Best Score', '${widget.bestScore}'),
                    _statRow('Coins Collected', '${widget.coinsCollected}'),
                    _statRow('Survived', _formatTime(widget.survivalSeconds)),
                    if (widget.newlyUnlockedAchievements.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Achievement Unlocked!',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.newlyUnlockedAchievements.map(
                        (a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.amberAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                a.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    GameButton(
                      label: 'Play Again',
                      icon: Icons.replay,
                      colors: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const GameScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    GameButton(
                      label: 'Home',
                      icon: Icons.home,
                      colors: const [Color(0xFF757F9A), Color(0xFFD7DDE8)],
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }
}
