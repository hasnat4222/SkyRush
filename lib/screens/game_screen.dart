import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../game/sky_rush_game.dart';
import '../game/obstacle.dart';
import '../game/coin.dart';
import '../game/power_up.dart';
import '../game/player.dart';
import '../models/character_model.dart';
import '../services/storage_service.dart';
import '../widgets/character_painter.dart';
import '../widgets/game_button.dart';
import '../widgets/score_display.dart';
import '../models/achievement_model.dart';
import 'game_over_screen.dart';

// GAME SCREEN
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _storage = StorageService.instance;

  SkyRushGame? _game;
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;

  bool _paused = false;
  bool _endingHandled = false;
  bool _pausedByLifecycle = false;

  // Countdown before gameplay
  int _countdown = 3;
  bool get _isCountingDown => _countdown > 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = createTicker(_onTick)..start();
    _startCountdown();
  }

  @override
  // APP LIFECYCLE: Pause & resume when app theke ber hoi.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_pausedByLifecycle && mounted) {
        setState(() {
          _paused = false;
          _pausedByLifecycle = false;
          _lastTick = Duration.zero;
        });
      }
      return;
    }

    if (!_paused && mounted) {
      setState(() {
        _paused = true;
        _pausedByLifecycle = true;
      });
    }
  }

  // COUNTDOWN 3,2,1
  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(milliseconds: 600));
    }
    if (!mounted) return;
    setState(() => _countdown = 0);
    _lastTick = Duration.zero;
  }

  void _ensureGameInitialized(Size size) {
    _game ??= SkyRushGame(screenWidth: size.width, screenHeight: size.height);
  }

  // game loop & ticker
  void _onTick(Duration elapsed) {
    final game = _game;
    if (game == null) return;
    if (_paused || _isCountingDown) {
      _lastTick = elapsed;
      return;
    }

    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }

    var dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    dt = dt.clamp(0.0, 0.05).toDouble();

    final wasGameOver = game.isGameOver;
    game.update(dt);

    if (!wasGameOver && game.isGameOver) {
      _handleGameEnd(game);
      return;
    }

    if (mounted) setState(() {});
  }

  // game over er por
  Future<void> _handleGameEnd(SkyRushGame game) async {
    if (_endingHandled) return;
    _endingHandled = true;

    final isNewHighScore = game.score > _storage.bestScore;
    await _storage.setBestScoreIfHigher(game.score);
    await _storage.addCoins(game.coinsThisRun);
    await _storage.setBestSurvivalSecondsIfHigher(game.elapsedSeconds.floor());

    await _storage.markHasPlayedBefore();

    final newlyUnlocked = <AchievementModel>[];
    Future<void> check(String id, bool condition) async {
      if (condition) {
        final wasNew = await _storage.unlockAchievement(id);
        if (wasNew) {
          newlyUnlocked.add(AchievementModel.all.firstWhere((a) => a.id == id));
        }
      }
    }

    await check('first_flight', true);
    await check('rookie', game.score >= 25);
    await check('sky_master', game.score >= 100);
    await check('coin_hunter', _storage.totalCoinsCollected >= 50);
    await check('survivor', game.elapsedSeconds >= 60);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameOverScreen(
          score: game.score,
          bestScore: _storage.bestScore,
          coinsCollected: game.coinsThisRun,
          survivalSeconds: game.elapsedSeconds.floor(),
          isNewHighScore: isNewHighScore,
          newlyUnlockedAchievements: newlyUnlocked,
        ),
      ),
    );
  }

  // puase, restart
  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _restart() {
    setState(() {
      _endingHandled = false;
      _paused = false;
      _countdown = 3;
      final size = _game == null
          ? const Size(360, 640)
          : Size(_game!.screenWidth, _game!.screenHeight);
      _game = SkyRushGame(screenWidth: size.width, screenHeight: size.height);
      _lastTick = Duration.zero;
    });
    _startCountdown();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_isCountingDown || _paused) return;
    final game = _game;
    if (game == null || game.isGameOver) return;
    game.flap();
  }

  // GAME UI
  @override
  Widget build(BuildContext context) {
    final character = CharacterModel.byId(_storage.selectedCharacterId);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _ensureGameInitialized(size);
          _game!.resize(size.width, size.height);
          final game = _game!;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GamePainter(game: game, character: character),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ScoreDisplay(
                                score: game.score,
                                coins: game.coinsThisRun,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _togglePause,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (game.player.speedBoostActive ||
                            game.player.shieldActive)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8,
                                children: [
                                  if (game.player.shieldActive)
                                    _statusChip('SHIELD', Colors.cyanAccent),
                                  if (game.player.speedBoostActive)
                                    _statusChip(
                                      'SPEED BOOST',
                                      Colors.yellowAccent,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (game.elapsedSeconds < 4 && game.score == 0)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'TAP ANYWHERE TO FLY',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_isCountingDown) _countdownOverlay(),
                if (_paused) _pauseOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _countdownOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: Text(
            _countdown == 0 ? 'GO!' : '$_countdown',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pauseOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PAUSED',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 28),
              GameButton(
                label: 'Resume',
                icon: Icons.play_arrow,
                colors: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
                onPressed: _togglePause,
              ),
              const SizedBox(height: 14),
              GameButton(
                label: 'Restart',
                icon: Icons.replay,
                onPressed: _restart,
              ),
              const SizedBox(height: 14),
              GameButton(
                label: 'Home',
                icon: Icons.home,
                colors: const [Color(0xFF757F9A), Color(0xFFD7DDE8)],
                onPressed: _goHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// drawing

class _GamePainter extends CustomPainter {
  final SkyRushGame game;
  final CharacterModel character;

  _GamePainter({required this.game, required this.character});

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);

    for (final o in game.obstacles) {
      _paintObstacle(canvas, size, o);
    }
    for (final c in game.coins) {
      _paintCoin(canvas, c);
    }
    for (final p in game.powerUps) {
      _paintPowerUp(canvas, p);
    }
    _paintPlayer(canvas);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.08);
    for (int i = 0; i < 4; i++) {
      final cx =
          (size.width * (i / 4) + (game.elapsedSeconds * 12) % size.width) %
          size.width;
      canvas.drawCircle(Offset(cx, size.height * 0.2 + i * 40), 40, cloudPaint);
      canvas.drawCircle(
        Offset(cx + 30, size.height * 0.2 + i * 40),
        30,
        cloudPaint,
      );
    }
  }

  void _paintObstacle(Canvas canvas, Size size, Obstacle o) {
    final gatePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      ).createShader(Rect.fromLTWH(o.x, 0, Obstacle.width, size.height))
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = const Color(0xFF00C6FF).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Top bar of the energy gate.
    final topRect = RRect.fromLTRBAndCorners(
      o.x,
      0,
      o.x + Obstacle.width,
      o.gapTop,
      bottomLeft: const Radius.circular(10),
      bottomRight: const Radius.circular(10),
    );
    canvas.drawRRect(topRect, glowPaint);
    canvas.drawRRect(topRect, gatePaint);

    // Bottom bar of the energy gate.
    final bottomRect = RRect.fromLTRBAndCorners(
      o.x,
      o.gapBottom,
      o.x + Obstacle.width,
      size.height,
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
    );
    canvas.drawRRect(bottomRect, glowPaint);
    canvas.drawRRect(bottomRect, gatePaint);
  }

  //coin
  void _paintCoin(Canvas canvas, Coin c) {
    final y = c.y - c.bobOffset;
    final paint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(Offset(c.x, y), Coin.radius, paint);
    final innerPaint = Paint()..color = const Color(0xFFFFA000);
    canvas.drawCircle(Offset(c.x, y), Coin.radius * 0.5, innerPaint);
  }

  void _paintPowerUp(Canvas canvas, PowerUp p) {
    final color = p.type == PowerUpType.shield
        ? Colors.cyanAccent
        : Colors.yellowAccent;
    final paint = Paint()..color = color.withOpacity(0.9);
    final glow = Paint()
      ..color = color.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(p.x, p.y), PowerUp.radius, glow);
    canvas.drawCircle(Offset(p.x, p.y), PowerUp.radius * 0.7, paint);

    final icon = p.type == PowerUpType.shield ? Icons.shield : Icons.bolt;
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: PowerUp.radius,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(p.x - textPainter.width / 2, p.y - textPainter.height / 2),
    );
  }

  void _paintPlayer(Canvas canvas) {
    final player = game.player;
    canvas.save();
    canvas.translate(player.x, player.y);

    final painter = CharacterPainter(
      bodyColor: character.bodyColor,
      accentColor: character.accentColor,
      rotation: player.rotation,
      shieldActive: player.shieldActive,
    );
    final rectSize = Size(Player.radius * 2.4, Player.radius * 2.4);
    canvas.translate(-rectSize.width / 2, -rectSize.height / 2);
    painter.paint(canvas, rectSize);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GamePainter oldDelegate) => true;
}
