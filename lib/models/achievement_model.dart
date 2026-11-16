enum AchievementType { playCount, score, coins, survivalSeconds }

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final int target;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.target,
  });

  static const List<AchievementModel> all = [
    AchievementModel(
      id: 'first_flight',
      title: 'First Flight',
      description: 'Start the game for the first time.',
      type: AchievementType.playCount,
      target: 1,
    ),
    AchievementModel(
      id: 'rookie',
      title: 'Rookie',
      description: 'Reach a score of 25 in a single run.',
      type: AchievementType.score,
      target: 25,
    ),
    AchievementModel(
      id: 'sky_master',
      title: 'Sky Master',
      description: 'Reach a score of 100 in a single run.',
      type: AchievementType.score,
      target: 100,
    ),
    AchievementModel(
      id: 'coin_hunter',
      title: 'Coin Hunter',
      description: 'Collect 50 coins in total.',
      type: AchievementType.coins,
      target: 50,
    ),
    AchievementModel(
      id: 'survivor',
      title: 'Survivor',
      description: 'Survive for 60 seconds in a single run.',
      type: AchievementType.survivalSeconds,
      target: 60,
    ),
  ];
}
