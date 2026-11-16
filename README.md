# 🚀 SkyRush
### Dodge. Fly. Survive.

**SkyRush** is a 2D endless arcade flying and dodging game developed using Flutter and Dart as a Mobile App Development academic project.

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Game Features](#-game-features)
- [Technologies Used](#-technologies-used)
- [Game Characters and Unlocking System](#-game-characters-and-unlocking-system)
- [Scoring, Coins and Achievement System](#-scoring-coins-and-achievement-system)
- [Project Screenshots](#-project-screenshots)
- [Project Folder Structure](#-project-folder-structure)
- [Dependencies](#-dependencies)
- [Installation and Setup Guide](#-installation-and-setup-guide)
- [How to Run the Game](#-how-to-run-the-game)
- [Development Details](#-development-details)
- [Known Limitations](#-known-limitations)
- [Future Improvements](#-future-improvements)
- [Contributors](#-contributors)

---

## 🎮 Project Overview

SkyRush is a 2D endless arcade flying and dodging game made with Flutter and Dart. The player taps the screen to flap upward, while gravity continuously pulls the character downward. The objective is to navigate through gaps in incoming energy gates, avoid obstacles, collect coins, and achieve the highest possible score.

The game ends when the player collides with an obstacle or reaches the top or bottom boundary without protection.

The project is developed as an Android mobile application for a Mobile App Development course. Game objects and character artwork are drawn using Flutter's CustomPainter, without requiring external image assets for the game visuals.

| Project Detail | Information |
|---|---|
| Project Name | SkyRush |
| Tagline | Dodge. Fly. Survive. |
| Game Type | 2D Endless Arcade Flying / Dodge Game |
| Framework | Flutter |
| Programming Language | Dart |
| Target Platform | Android |
| App Version | 1.1.0+2 |

---

## ✨ Game Features

- **Tap-to-Fly Controls:** Tap the screen to make the character flap upward.
- **Endless Energy Gates:** Navigate through randomly positioned obstacle gaps.
- **Increasing Difficulty:** Game difficulty increases as the score grows.
- **Coin Collection:** Collect coins during gameplay and use them to unlock characters.
- **Power-Ups:** Use Shield and Speed Boost power-ups during gameplay.
- **Pause and Resume:** Pause, resume, restart, or return to the home screen.
- **Countdown System:** A 3-2-1 countdown appears before gameplay starts.
- **Score System:** Earn points by successfully passing energy gates.
- **Best Score Tracking:** Save and view the highest achieved score.
- **Character Selection:** Unlock and select different playable characters.
- **Achievement System:** Complete challenges and unlock achievements.
- **Game Over Summary:** View score, best score, collected coins, and survival time.
- **Local Data Storage:** Save game progress and settings on the device.
- **Portrait Orientation:** Designed for portrait mobile gameplay.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Application logic and game mechanics |
| CustomPainter | Drawing game characters and objects |
| Canvas | Rendering game graphics |
| Ticker | Updating the game loop |
| SharedPreferences | Saving game progress locally |
| Android Gradle | Android application build configuration |

---

## 🧑‍🚀 Game Characters and Unlocking System

SkyRush includes four playable characters. The default character is free, while the remaining characters can be unlocked using collected coins.

| Character | Unlock Cost |
|---|---:|
| Sky | Free |
| Bolt | 100 Coins |
| Luna | 250 Coins |
| Blaze | 500 Coins |

Players can purchase characters using their collected coins and select unlocked characters for gameplay.

---

## 🏆 Scoring, Coins and Achievement System

### Score and Coins

- Players earn one point for passing an energy gate.
- Coins can be collected during gameplay.
- Collected coins are added to the saved balance when a run ends.
- Best score and survival time are saved locally.
- Coins can be used to unlock additional characters.

### Achievements

The game includes five achievements:

| Achievement | Requirement |
|---|---|
| First Flight | Complete the first run |
| Rookie | Reach a score of 25 in one run |
| Sky Master | Reach a score of 100 in one run |
| Coin Hunter | Collect 50 coins in total |
| Survivor | Survive for 60 seconds in one run |

Achievement progress and unlocks are stored locally on the device.

---

## 📸 Project Screenshots

Screenshots of the actual game will be added here.

| Home Screen | Gameplay |
|---|---|
| ![Home Screen](screenshots/home.png) | ![Gameplay](screenshots/gameplay.png) |

| Character Selection | Achievements |
|---|---|
| ![Character Selection](screenshots/characters.png) | ![Achievements](screenshots/achievements.png) |

| Game Over | High Scores |
|---|---|
| ![Game Over](screenshots/game-over.png) | ![High Scores](screenshots/high-scores.png) |

---

## 📁 Project Folder Structure

```text
SkyRush/
├── android/
│   ├── app/
│   ├── gradle/
│   └── build.gradle.kts
│
├── lib/
│   ├── game/
│   │   ├── coin.dart
│   │   ├── obstacle.dart
│   │   ├── player.dart
│   │   ├── power_up.dart
│   │   └── sky_rush_game.dart
│   │
│   ├── models/
│   │   ├── achievement_model.dart
│   │   └── character_model.dart
│   │
│   ├── screens/
│   │   ├── achievement_screen.dart
│   │   ├── character_screen.dart
│   │   ├── game_over_screen.dart
│   │   ├── game_screen.dart
│   │   ├── high_score_screen.dart
│   │   ├── home_screen.dart
│   │   ├── settings_screen.dart
│   │   └── splash_screen.dart
│   │
│   ├── services/
│   │   └── storage_service.dart
│   │
│   ├── widgets/
│   │   ├── character_painter.dart
│   │   ├── game_button.dart
│   │   └── score_display.dart
│   │
│   └── main.dart
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

---

## 📦 Dependencies

The project uses the following packages:

### Runtime Dependencies

| Package | Version | Purpose |
|---|---|---|
| Flutter SDK | SDK | Application framework |
| shared_preferences | ^2.2.2 | Local data storage |
| cupertino_icons | ^1.0.6 | Icon package |

### Development Dependencies

| Package | Version | Purpose |
|---|---|---|
| flutter_test | SDK | Widget testing |
| flutter_lints | ^3.0.0 | Code quality and lint rules |

---

## ⚙️ Installation and Setup Guide

Follow these steps to set up the project on your computer.

**1. Install Flutter**

Install the Flutter SDK and configure the Android development environment.

**2. Clone the Repository**

```bash
git clone https://github.com/hasnat4222/SkyRush.git
```

**3. Navigate to the Project Folder**

```bash
cd SkyRush
```

**4. Install Dependencies**

```bash
flutter pub get
```

**5. Check Flutter Configuration**

```bash
flutter doctor
```

---

## ▶️ How to Run the Game

**1.** Start an Android Emulator or connect an Android device.

**2.** Check available devices:

```bash
flutter devices
```

**3.** Run the application:

```bash
flutter run
```

To generate a release APK:

```bash
flutter build apk --release
```

Note: Configure a proper release signing key before distributing the application publicly.

---

## 💻 Development Details

- The application starts from `main.dart`.
- The game simulation is managed by `SkyRushGame`.
- Player movement uses gravity and upward flap mechanics.
- Obstacles, coins, and power-ups are managed through separate game classes.
- `GameScreen` handles gameplay updates and rendering.
- `CustomPainter` is used to draw game objects and characters.
- `StorageService` manages locally saved game progress using SharedPreferences.
- Separate screens are used for the home menu, gameplay, character selection, achievements, high scores, settings, and game over.

---

## ⚠️ Known Limitations

- The game currently does not include sound or vibration features.
- Game progress is stored locally on the device.
- Progress is not synchronized between multiple devices.
- The project currently includes Android platform configuration only.
- Character and game graphics are created using Flutter drawing tools rather than external sprite images.

---

## 🚀 Future Improvements

Possible future improvements include:

- Adding background music and sound effects.
- Introducing more characters and obstacle variations.
- Adding cloud-based game progress synchronization.
- Improving visual effects and animations.
- Expanding automated testing.
- Preparing a production-ready Android release build.

---

## 👨‍💻 Contributors

This project was collaboratively developed by:

| Name | Role |
|---|---|
| **Hasnat Hossain** | Game Development & Project Implementation |
| **Shahriar Asif** | Game Development & Project Implementation |

**Project:** SkyRush – Dodge. Fly. Survive.

**Repository:** [github.com/hasnat4222/SkyRush](https://github.com/hasnat4222/SkyRush)

---

⭐ If you like this project, consider giving the repository a star!

**Developed with Flutter & Dart.**
