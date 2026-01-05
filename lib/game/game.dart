import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:testLast-runner-05/player.dart';
import 'package:testLast-runner-05/obstacle.dart';
import 'package:testLast-runner-05/collectible.dart';
import 'package:testLast-runner-05/analytics.dart';
import 'package:testLast-runner-05/ads.dart';
import 'package:testLast-runner-05/storage.dart';

/// The main game class for the 'testLast-runner-05' game.
class testLast-runner-05Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The list of obstacles.
  final List<Obstacle> _obstacles = [];

  /// The list of collectibles.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// The analytics service.
  final AnalyticsService _analytics = AnalyticsService();

  /// The ads service.
  final AdsService _ads = AdsService();

  /// The storage service.
  final StorageService _storage = StorageService();

  /// Initializes the game.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadLevel(1);
  }

  /// Loads a specific level.
  void _loadLevel(int levelNumber) {
    // Load level data from storage or other source
    // Initialize player, obstacles, and collectibles
    _player = Player();
    _obstacles.addAll(_loadObstacles(levelNumber));
    _collectibles.addAll(_loadCollectibles(levelNumber));
    // Add components to the game world
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);
  }

  /// Handles the tap input.
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  /// Updates the game state and components.
  @override
  void update(double dt) {
    super.update(dt);
    switch (_gameState) {
      case GameState.playing:
        _updatePlaying(dt);
        break;
      case GameState.paused:
        // Handle paused state
        break;
      case GameState.gameOver:
        // Handle game over state
        break;
      case GameState.levelComplete:
        // Handle level complete state
        break;
    }
  }

  /// Updates the game while in the playing state.
  void _updatePlaying(double dt) {
    _player.update(dt);
    _updateObstacles(dt);
    _updateCollectibles(dt);
    _checkCollisions();
    _updateScore(dt);
  }

  /// Updates the obstacles.
  void _updateObstacles(double dt) {
    for (final obstacle in _obstacles) {
      obstacle.update(dt);
    }
  }

  /// Updates the collectibles.
  void _updateCollectibles(double dt) {
    for (final collectible in _collectibles) {
      collectible.update(dt);
    }
  }

  /// Checks for collisions between the player and obstacles/collectibles.
  void _checkCollisions() {
    // Check for collisions and update game state accordingly
    if (_player.isColliding(_obstacles)) {
      _gameOver();
    }
    if (_player.isCollecting(_collectibles)) {
      _collectCoins();
    }
  }

  /// Updates the score.
  void _updateScore(double dt) {
    // Update the score based on time elapsed or other factors
    _score += (dt * 10).toInt();
  }

  /// Handles the game over state.
  void _gameOver() {
    _gameState = GameState.gameOver;
    // Trigger game over sequence (display score, show retry/menu options, etc.)
    _analytics.logGameOver(_score);
    _ads.showInterstitialAd();
  }

  /// Handles the collection of coins.
  void _collectCoins() {
    // Increment the score, update UI, and trigger any other coin collection logic
    _score += 10;
    _analytics.logCoinCollected();
    _storage.saveHighScore(_score);
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}