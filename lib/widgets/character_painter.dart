import 'dart:math';
import 'package:flutter/material.dart';

class CharacterPainter extends CustomPainter {
  final Color bodyColor;
  final Color accentColor;
  final double rotation;
  final bool shieldActive;

  CharacterPainter({
    required this.bodyColor,
    required this.accentColor,
    this.rotation = 0,
    this.shieldActive = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final r = min(size.width, size.height) / 2;

    if (shieldActive) {
      final shieldPaint = Paint()
        ..color = Colors.cyanAccent.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset.zero, r * 1.25, shieldPaint);
    }

    // Wings
    final wingPaint = Paint()..color = accentColor;
    final topWing = Path()
      ..moveTo(-r * 0.2, -r * 0.1)
      ..lineTo(-r * 1.3, -r * 0.9)
      ..lineTo(-r * 0.4, r * 0.1)
      ..close();
    final bottomWing = Path()
      ..moveTo(-r * 0.2, r * 0.1)
      ..lineTo(-r * 1.3, r * 0.9)
      ..lineTo(-r * 0.4, -r * 0.1)
      ..close();
    canvas.drawPath(topWing, wingPaint);
    canvas.drawPath(bottomWing, wingPaint);

    // Body: rounded teardrop shape.
    final bodyPaint = Paint()..color = bodyColor;
    final bodyRect = Rect.fromCenter(
      center: Offset.zero,
      width: r * 1.9,
      height: r * 1.5,
    );
    final bodyPath = Path()
      ..addOval(bodyRect)
      ..close();
    canvas.drawShadow(bodyPath, Colors.black, 3, false);
    canvas.drawPath(bodyPath, bodyPaint);

    // Visor.
    final visorPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(r * 0.25, 0),
        width: r * 0.9,
        height: r * 0.55,
      ),
      visorPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return oldDelegate.bodyColor != bodyColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.rotation != rotation ||
        oldDelegate.shieldActive != shieldActive;
  }
}
