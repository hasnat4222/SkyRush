import 'dart:math' show sin;

class Coin {
  static const double radius = 12;

  double x;
  double y;
  bool collected;

  double phase;

  Coin({
    required this.x,
    required this.y,
    this.collected = false,
    this.phase = 0,
  });

  void update(double dt, double speed) {
    x -= speed * dt;
    phase += dt * 4;
  }

  double get bobOffset => sin(phase) * 4;

  bool get isOffScreen => x + radius < 0;
}
