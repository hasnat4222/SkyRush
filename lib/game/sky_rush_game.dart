import 'dart:math';
import 'player.dart';
import 'obstacle.dart';
import 'coin.dart';
import 'power_up.dart';

class SkyRushGame {
  final Random _rng = Random();

  late Player player;
  final List<Obstacle> obstacles = [];
  final List<Coin> coins = [];
  final List<PowerUp> powerUps = [];

  double screenWidth;
  double screenHeight;

  int score = 0;
  int coinsThisRun = 0;
  double elapsedSeconds = 0;
  bool isGameOver = false;

  static const double gravity = 900; // px/s^2
  static const double flapStrength = 320; // px/s
  static const double maxFallSpeed = 620; // px/s

  double _obstacleSpeed = 170;
  double _spawnInterval = 1.7;
  double _gapHeight = 230;
  static const double _minGapHeight = 150;
  static const double _maxObstacleSpeed = 320;
  static const double _minSpawnInterval = 1.05;

  double _spawnTimer = 0;
  double _coinSpawnTimer = 0;
  double _powerUpSpawnTimer = 1.5;

  double shieldTimer = 0;
  double speedBoostTimer = 0;
  double _collisionGraceTimer = 0;

  SkyRushGame({required this.screenWidth, required this.screenHeight}) {
    player = Player(x: screenWidth * 0.28, y: screenHeight / 2);
  }

  void resize(double width, double height) {
    screenWidth = width;
    screenHeight = height;
    player.x = width * 0.28;
  }

  void flap() {
    if (isGameOver) return;
    player.flap(flapStrength);
  }

  void update(double dt) {
    if (isGameOver) return;
    elapsedSeconds += dt;
    _collisionGraceTimer = (_collisionGraceTimer - dt).clamp(0, 1).toDouble();

    final effectiveSpeed =
        _obstacleSpeed * (player.speedBoostActive ? 0.6 : 1.0);

    player.update(dt, gravity, maxFallSpeed);

    if (player.y - Player.radius <= 0) {
      player.y = Player.radius;
      _handleCollision(reboundVelocity: 280);
    } else if (player.y + Player.radius >= screenHeight) {
      player.y = screenHeight - Player.radius;
      _handleCollision(reboundVelocity: -280);
    }

    _updateObstacles(dt, effectiveSpeed);
    _updateCoins(dt, effectiveSpeed);
    _updatePowerUps(dt, effectiveSpeed);
    _updateTimers(dt);
    _scaleDifficulty();
  }

  void _updateObstacles(double dt, double speed) {
    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnObstacle();
      _spawnTimer = _spawnInterval;
    }

    for (final o in obstacles) {
      o.update(dt, speed);

      if (!o.scored && o.x + Obstacle.width < player.x - Player.radius) {
        o.scored = true;
        score++;
      }

      final horizontallyOverlapping =
          player.x + Player.radius > o.x &&
          player.x - Player.radius < o.x + Obstacle.width;
      if (horizontallyOverlapping) {
        final withinGap =
            player.y - Player.radius > o.gapTop &&
            player.y + Player.radius < o.gapBottom;
        if (!withinGap) {
          _handleCollision();
          if (isGameOver) break;
        }
      }
    }

    obstacles.removeWhere((o) => o.isOffScreen);
  }

  //random gap
  void _spawnObstacle() {
    const margin = 70.0;
    final usableHeight = screenHeight - margin * 2;
    final gapCenterY =
        margin +
        _rng.nextDouble() * (usableHeight - _gapHeight) +
        _gapHeight / 2;
    obstacles.add(
      Obstacle(
        x: screenWidth + Obstacle.width,
        gapCenterY: gapCenterY.clamp(margin, screenHeight - margin).toDouble(),
        gapHeight: _gapHeight,
      ),
    );
  }

  void _updateCoins(double dt, double speed) {
    _coinSpawnTimer -= dt;
    if (_coinSpawnTimer <= 0) {
      _spawnCoin();
      _coinSpawnTimer = 1.1 + _rng.nextDouble() * 1.2;
    }

    for (final c in coins) {
      if (c.collected) continue;
      c.update(dt, speed);

      final dx = c.x - player.x;
      final dy = c.y - c.bobOffset - player.y;
      const collectionRadius = Coin.radius + Player.radius * 0.72;
      if (dx * dx + dy * dy < collectionRadius * collectionRadius) {
        c.collected = true;
        coinsThisRun++;
      }
    }

    coins.removeWhere((c) => c.isOffScreen || c.collected);
  }

  void _spawnCoin() {
    final y = 60 + _rng.nextDouble() * (screenHeight - 120);
    coins.add(Coin(x: screenWidth + Coin.radius, y: y));
  }

  void _updatePowerUps(double dt, double speed) {
    _powerUpSpawnTimer -= dt;
    if (_powerUpSpawnTimer <= 0) {
      _spawnPowerUp();
      _powerUpSpawnTimer = 9 + _rng.nextDouble() * 6;
    }

    for (final p in powerUps) {
      if (p.collected) continue;
      p.update(dt, speed);

      final dx = p.x - player.x;
      final dy = p.y - player.y;
      const collectionRadius = PowerUp.radius + Player.radius * 0.72;
      if (dx * dx + dy * dy < collectionRadius * collectionRadius) {
        p.collected = true;
        if (p.type == PowerUpType.shield) {
          player.shieldActive = true;
          shieldTimer = 6;
        } else {
          player.speedBoostActive = true;
          speedBoostTimer = 5;
        }
      }
    }

    powerUps.removeWhere((p) => p.isOffScreen || p.collected);
  }

  void _spawnPowerUp() {
    final y = 80 + _rng.nextDouble() * (screenHeight - 160);
    final type = _rng.nextBool() ? PowerUpType.shield : PowerUpType.speedBoost;
    powerUps.add(PowerUp(x: screenWidth + PowerUp.radius, y: y, type: type));
  }

  void _updateTimers(double dt) {
    if (player.shieldActive) {
      shieldTimer -= dt;
      if (shieldTimer <= 0) player.shieldActive = false;
    }
    if (player.speedBoostActive) {
      speedBoostTimer -= dt;
      if (speedBoostTimer <= 0) player.speedBoostActive = false;
    }
  }

  void _scaleDifficulty() {
    final level = score ~/ 10;
    _obstacleSpeed = (170 + level * 14)
        .toDouble()
        .clamp(170, _maxObstacleSpeed)
        .toDouble();
    _gapHeight = (230 - level * 8)
        .toDouble()
        .clamp(_minGapHeight, 230)
        .toDouble();
    _spawnInterval = (1.7 - level * 0.05)
        .toDouble()
        .clamp(_minSpawnInterval, 1.7)
        .toDouble();
  }

  void _handleCollision({double? reboundVelocity}) {
    if (_collisionGraceTimer > 0) return;
    if (player.shieldActive) {
      player.shieldActive = false;
      shieldTimer = 0;
      _collisionGraceTimer = 0.8;
      if (reboundVelocity != null) player.velocity = reboundVelocity;
      return;
    }
    isGameOver = true;
  }
}
