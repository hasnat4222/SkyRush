enum PowerUpType { shield, speedBoost }

class PowerUp {
  static const double radius = 16;

  double x;
  double y;
  final PowerUpType type;
  bool collected;

  PowerUp({
    required this.x,
    required this.y,
    required this.type,
    this.collected = false,
  });

  void update(double dt, double speed) {
    x -= speed * dt;
  }

  bool get isOffScreen => x + radius < 0;
}
