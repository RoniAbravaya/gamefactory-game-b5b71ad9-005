import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-runner-05/player.dart';
import 'package:testLast-runner-05/obstacle.dart';
import 'package:testLast-runner-05/collectible.dart';

/// The main game scene that handles the core game loop and logic.
class GameScene extends FlameGame with TapDetector {
  late Player _player;
  final List<Obstacle> _obstacles = [];
  final List<Collectible> _collectibles = [];
  int _score = 0;
  bool _isPaused = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _loadLevel();
  }

  /// Loads the current level, setting up the player, obstacles, and collectibles.
  void _loadLevel() {
    _player = Player()..position = Vector2(100, size.y - 100);
    add(_player);

    for (int i = 0; i < 10; i++) {
      final obstacle = Obstacle()
        ..position = Vector2(i * 200 + 500, size.y - 100);
      _obstacles.add(obstacle);
      add(obstacle);
    }

    for (int i = 0; i < 20; i++) {
      final collectible = Collectible()
        ..position = Vector2(i * 100 + 300, size.y - 150);
      _collectibles.add(collectible);
      add(collectible);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isPaused) {
      _updatePlayer(dt);
      _updateObstacles(dt);
      _updateCollectibles(dt);
      _checkCollisions();
      _updateScore();
    }
  }

  void _updatePlayer(double dt) {
    _player.update(dt);
  }

  void _updateObstacles(double dt) {
    for (final obstacle in _obstacles) {
      obstacle.update(dt);
    }
  }

  void _updateCollectibles(double dt) {
    for (final collectible in _collectibles) {
      collectible.update(dt);
    }
  }

  void _checkCollisions() {
    if (_player.isColliding(_obstacles)) {
      _handleGameOver();
    }

    final collectedCoins = _player.collectCoins(_collectibles);
    _score += collectedCoins;
  }

  void _updateScore() {
    // Update the score display
  }

  void _handleGameOver() {
    // Show game over screen and allow the player to retry
    _isPaused = true;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (!_isPaused) {
      _player.jump();
    }
  }

  void pause() {
    _isPaused = true;
  }

  void resume() {
    _isPaused = false;
  }
}