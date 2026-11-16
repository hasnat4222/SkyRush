import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HighScoreScreen extends StatelessWidget {
  const HighScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _statCard(
              'Best Score',
              '${storage.bestScore}',
              Icons.emoji_events,
              const Color(0xFFFFD54F),
            ),
            _statCard(
              'Total Coins Collected',
              '${storage.totalCoinsCollected}',
              Icons.monetization_on,
              const Color(0xFFFFB300),
            ),
            _statCard(
              'Best Survival Time',
              '${storage.bestSurvivalSeconds}s',
              Icons.timer,
              const Color(0xFF4FC3F7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
