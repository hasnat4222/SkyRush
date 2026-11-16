class Obstacle {
  static const double width = 70;

  double x;

  final double gapCenterY;

  final double gapHeight;

  bool scored;

  Obstacle({
    required this.x,
    required this.gapCenterY,
    required this.gapHeight,
    this.scored = false,
  });

  double get gapTop => gapCenterY - gapHeight / 2;
  double get gapBottom => gapCenterY + gapHeight / 2;

  void update(double dt, double speed) {
    x -= speed * dt;
  }

  bool get isOffScreen => x + width < 0;
}
