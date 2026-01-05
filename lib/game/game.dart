import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-runner-05/analytics_service.dart';
import 'package:testLast-runner-05/game_controller.dart';
import 'package:testLast-runner-05/level_config.dart';
import 'package:testLast-runner-05/player.dart';
import 'package:testLast-runner-05/obstacle.dart';
import 'package:testLast-runner-05/coin.dart';
import 'package:testLast-runner-05/ui_overlay.dart';

/// The main FlameGame subclass for the 'testLast-runner-05' game.
class testLast-runner-05Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player character.
  late Player _player;

  /// The level configuration.
  late LevelConfig _levelConfig;

  /// The game score.
  int _score = 0;

  /// The number of lives the player has.
  int _lives = 3;

  /// The game controller.
  late GameController _gameController;

  /// The analytics service.
  late AnalyticsService _analyticsService;

  /// The UI overlay.
  late UIOverlay _uiOverlay;

  @override
  Future<void> onLoad() async {
    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(720, 1280));
    camera.followComponent(_player);

    // Load the level configuration
    _levelConfig = await LevelConfig.load();

    // Create the player
    _player = Player();
    add(_player);

    // Create the game controller
    _gameController = GameController(this);
    add(_gameController);

    // Create the UI overlay
    _uiOverlay = UIOverlay(this);
    add(_uiOverlay);

    // Initialize the analytics service
    _analyticsService = AnalyticsService();
    _analyticsService.logGameStart();
  }

  @override
  void onTapDown(TapDownInfo info) {
    // Handle player jump input
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state
    switch (_gameState) {
      case GameState.playing:
        // Update the player and check for collisions
        _player.update(dt);
        _checkCollisions();

        // Update the score
        _updateScore(dt);

        // Check for level completion
        if (_player.position.x >= _levelConfig.levelLength) {
          _gameState = GameState.levelComplete;
          _analyticsService.logLevelComplete();
        }
        break;
      case GameState.paused:
        // Pause the game
        break;
      case GameState.gameOver:
        // Handle game over state
        _analyticsService.logLevelFail();
        break;
      case GameState.levelComplete:
        // Handle level complete state
        break;
    }
  }

  void _checkCollisions() {
    // Check for collisions with obstacles
    for (final obstacle in obstacles) {
      if (_player.collides(obstacle)) {
        _handlePlayerDeath();
        return;
      }
    }

    // Check for collisions with coins
    for (final coin in coins) {
      if (_player.collides(coin)) {
        _collectCoin(coin);
      }
    }
  }

  void _handlePlayerDeath() {
    // Decrement the player's lives
    _lives--;

    // If the player has no more lives, end the game
    if (_lives == 0) {
      _gameState = GameState.gameOver;
    } else {
      // Respawn the player
      _player.respawn();
    }
  }

  void _collectCoin(Coin coin) {
    // Remove the collected coin from the game
    remove(coin);

    // Update the score
    _score += coin.value;
    _analyticsService.logCoinCollected();
  }

  void _updateScore(double dt) {
    // Increase the score over time
    _score += (dt * _levelConfig.scorePerSecond).toInt();
    _uiOverlay.updateScore(_score);
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}