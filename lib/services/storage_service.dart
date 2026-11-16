import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._internal();
  static final StorageService instance = StorageService._internal();

  static const _kBestScore = 'best_score';
  static const _kCoins = 'coins';
  static const _kSelectedCharacter = 'selected_character';
  static const _kUnlockedCharacters = 'unlocked_characters';
  static const _kUnlockedAchievements = 'unlocked_achievements';
  static const _kTotalCoinsCollected = 'total_coins_collected';
  static const _kBestSurvivalSeconds = 'best_survival_seconds';
  static const _kHasPlayedBefore = 'has_played_before';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError('StorageService.init() must be called before use.');
    }
    return p;
  }

  // Score
  int get bestScore => _p.getInt(_kBestScore) ?? 0;
  Future<void> setBestScoreIfHigher(int score) async {
    if (score > bestScore) {
      await _p.setInt(_kBestScore, score);
    }
  }

  //  Coins
  int get coins => _p.getInt(_kCoins) ?? 0;
  Future<void> addCoins(int amount) async {
    await _p.setInt(_kCoins, coins + amount);
    await _p.setInt(_kTotalCoinsCollected, totalCoinsCollected + amount);
  }

  Future<void> spendCoins(int amount) async {
    final remaining = coins - amount;
    await _p.setInt(_kCoins, remaining < 0 ? 0 : remaining);
  }

  int get totalCoinsCollected => _p.getInt(_kTotalCoinsCollected) ?? 0;

  // Characters
  String get selectedCharacterId => _p.getString(_kSelectedCharacter) ?? 'sky';

  Future<void> setSelectedCharacter(String id) async {
    await _p.setString(_kSelectedCharacter, id);
  }

  List<String> get unlockedCharacterIds =>
      _p.getStringList(_kUnlockedCharacters) ?? ['sky'];

  Future<void> unlockCharacter(String id) async {
    final list = unlockedCharacterIds;
    if (!list.contains(id)) {
      list.add(id);
      await _p.setStringList(_kUnlockedCharacters, list);
    }
  }

  // Achievements
  List<String> get unlockedAchievementIds =>
      _p.getStringList(_kUnlockedAchievements) ?? [];

  Future<bool> unlockAchievement(String id) async {
    final list = unlockedAchievementIds;
    if (list.contains(id)) return false;
    list.add(id);
    await _p.setStringList(_kUnlockedAchievements, list);
    return true;
  }

  int get bestSurvivalSeconds => _p.getInt(_kBestSurvivalSeconds) ?? 0;
  Future<void> setBestSurvivalSecondsIfHigher(int seconds) async {
    if (seconds > bestSurvivalSeconds) {
      await _p.setInt(_kBestSurvivalSeconds, seconds);
    }
  }

  bool get hasPlayedBefore => _p.getBool(_kHasPlayedBefore) ?? false;
  Future<void> markHasPlayedBefore() async {
    await _p.setBool(_kHasPlayedBefore, true);
  }

  // Settings
  ///Reset Progress
  Future<void> resetAll() async {
    await _p.clear();
  }
}
