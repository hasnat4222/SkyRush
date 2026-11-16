import 'package:flutter/material.dart';
import '../models/character_model.dart';
import '../services/storage_service.dart';
import '../widgets/character_painter.dart';
import '../widgets/game_button.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final _storage = StorageService.instance;

  Future<void> _select(CharacterModel c) async {
    await _storage.setSelectedCharacter(c.id);
    setState(() {});
  }

  Future<void> _unlock(CharacterModel c) async {
    if (_storage.coins < c.cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough coins! Need ${c.cost}.')),
      );
      return;
    }
    await _storage.spendCoins(c.cost);
    await _storage.unlockCharacter(c.id);
    await _storage.setSelectedCharacter(c.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = _storage.unlockedCharacterIds;
    final selected = _storage.selectedCharacterId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        backgroundColor: const Color(0xFF2C5364),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFFFD54F),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_storage.coins}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: CharacterModel.all.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final c = CharacterModel.all[index];
            final isUnlocked = unlocked.contains(c.id);
            final isSelected = selected == c.id;

            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.greenAccent : Colors.transparent,
                  width: 3,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: CustomPaint(
                      painter: CharacterPainter(
                        bodyColor: c.bodyColor,
                        accentColor: c.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isUnlocked)
                    Text(
                      '${c.cost} coins',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  const Spacer(),
                  if (isSelected)
                    const Text(
                      'SELECTED',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    GameButton(
                      label: isUnlocked ? 'Select' : 'Unlock',
                      width: 130,
                      height: 40,
                      colors: isUnlocked
                          ? const [Color(0xFF43E97B), Color(0xFF38F9D7)]
                          : const [Color(0xFFFF7043), Color(0xFFFFB300)],
                      onPressed: () => isUnlocked ? _select(c) : _unlock(c),
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
