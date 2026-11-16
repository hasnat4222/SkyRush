import 'dart:math' show exp;

class Player {
  static const double radius = 22;

  double x;

  double y;

  double velocity;

  double rotation;

  bool shieldActive;

  bool speedBoostActive;

  Player({
    required this.x,
    required this.y,
    this.velocity = 0,
    this.rotation = 0,
    this.shieldActive = false,
    this.speedBoostActive = false,
  });

  void update(double dt, double gravity, double maxFallSpeed) {
    velocity += gravity * dt;
    if (velocity > maxFallSpeed) velocity = maxFallSpeed;
    y += velocity * dt;

    final targetRotation = (velocity / maxFallSpeed).clamp(-1.0, 1.0) * 0.6;

    rotation += (targetRotation - rotation) * (1 - exp(-8 * dt));
  }

  void flap(double flapStrength) {
    velocity = -flapStrength;
  }
}
