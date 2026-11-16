import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../services/storage_service.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  int _progressValue(AchievementModel a, StorageService storage) {
    switch (a.type) {
      case AchievementType.playCount:
        return storage.hasPlayedBefore ? 1 : 0;
      case AchievementType.score:
        return storage.bestScore;
      case AchievementType.coins:
        return storage.totalCoinsCollected;
      case AchievementType.survivalSeconds:
        return storage.bestSurvivalSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    final unlockedIds = storage.unlockedAchievementIds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: const Color(0xFF2C5364),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: AchievementModel.all.length,
          itemBuilder: (context, index) {
            final a = AchievementModel.all[index];
            final unlocked = unlockedIds.contains(a.id);
            final current = _progressValue(a, storage).clamp(0, a.target);
            final progress = a.target == 0 ? 1.0 : current / a.target;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: unlocked ? Colors.amberAccent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    unlocked ? Icons.emoji_events : Icons.lock_outline,
                    color: unlocked ? Colors.amberAccent : Colors.white38,
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: TextStyle(
                            color: unlocked ? Colors.amberAccent : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: unlocked ? 1.0 : progress.toDouble(),
                            minHeight: 8,
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation(
                              unlocked ? Colors.amberAccent : Colors.cyanAccent,
                            ),
                          ),
                        ),
                      ],
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
