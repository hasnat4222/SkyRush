# SkyRush — "Dodge. Fly. Survive."

An original 2D endless arcade tap-to-fly game built with Flutter + Dart.

## Improvements in this version

- Gameplay pauses when the app moves to the background and resumes when you return.
- Coin and power-up collection uses circular hit detection for fairer pickups.
- Coins float smoothly, and the flyer tilt animation stays consistent across refresh rates.
- A shield hit briefly protects the flyer and bounces it away from the screen edges.
- The game-over screen shows the time survived in addition to score and coins.

## 1. Setup

1. Install Flutter (stable channel) and Android Studio / VS Code with the
   Flutter & Dart plugins.
2. Extract this project, then open a terminal inside the `SkyRush/` folder.
3. Install packages:
   ```
   flutter pub get
   ```
4. Check for any issues:
   ```
   flutter analyze
   ```
5. Run on a connected Android device or emulator:
   ```
   flutter run
   ```

If `flutter run` can't find a device, start an Android emulator from
Android Studio's Device Manager first, or run `flutter emulators --launch <id>`.

## 2. Dependencies used (and why)

- `shared_preferences` — the only third-party package. It stores best
  score, coins, unlocked characters and unlocked achievements
  as simple key-value pairs on the device. No backend/Firebase is used
  because the game only needs small local values.
- Everything else (physics, obstacles, characters, gates) is drawn with
  Flutter's own `CustomPainter`/`Canvas` API, so no image assets are
  required for the game to run. Sound and vibration features are not included.

## 3. Project structure

```
lib/
  main.dart                    # App entry point, loads storage, launches Splash
  screens/
    splash_screen.dart         # Logo + tagline + auto-navigate to Home
    home_screen.dart           # Main menu
    game_screen.dart           # Game loop (Ticker), rendering, tap-to-fly, pause
    game_over_screen.dart      # Score summary, new-high-score, achievements
    character_screen.dart      # Unlock/select characters with coins
    achievement_screen.dart    # Achievement list with progress bars
    settings_screen.dart       # Reset progress and about
    high_score_screen.dart     # Best score / total coins / best survival time
  game/
    sky_rush_game.dart         # Core simulation: physics, spawning, collisions
    player.dart                # Player position/velocity/rotation
    obstacle.dart               # "Energy gate" obstacle data
    coin.dart                  # Coin data
    power_up.dart              # Shield / Speed Boost data
  models/
    character_model.dart       # The 4 characters (Sky/Bolt/Luna/Blaze)
    achievement_model.dart     # The 5 achievements
  services/
    storage_service.dart       # All shared_preferences read/writes
  widgets/
    game_button.dart           # Shared gradient button used everywhere
    score_display.dart         # Score/coin HUD pill during gameplay
    character_painter.dart     # CustomPainter that draws the flyer shape
```

## 4. How the gameplay loop works (for your viva)

- `GameScreen` creates one `Ticker` (`createTicker` from
  `SingleTickerProviderStateMixin`). Every display frame it fires
  `_onTick(elapsed)`.
- `_onTick` computes `dt` (seconds since the last frame) and calls
  `SkyRushGame.update(dt)`, then calls `setState` so the UI repaints.
- `SkyRushGame.update()` is plain Dart (no Flutter classes): it applies
  gravity to the player, moves obstacles/coins/power-ups left, spawns
  new ones on timers, checks collisions, and increases difficulty every
  10 points.
- All drawing happens in `_GamePainter` (a `CustomPainter`) inside
  `game_screen.dart` — it reads the current `SkyRushGame` state each
  frame and draws the sky, gates, coins, power-ups and the player.
- Tapping the screen calls `game.flap()`, which sets the player's
  vertical velocity to a fixed upward value — gravity pulls it back
  down every frame after that.

## 5. Known trade-offs / what's simplified

- Characters and the player are all drawn with `CustomPainter` shapes,
  not image sprites — this keeps the whole project buildable with no
  external art assets, and is easy to re-skin (just change 2 colors per
  character in `character_model.dart`).

## 6. If you hit a build error

Run `flutter analyze` and `flutter pub get` first. If a specific error
appears when you `flutter run`, copy the exact error text — the fix is
almost always in one file, matching the file paths listed above.
