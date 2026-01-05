import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-runner-05/game_objects/obstacle.dart';
import 'package:testLast-runner-05/game_objects/collectable.dart';

/// The player character in the runner game.
class Player extends SpriteAnimationComponent with HasGameRef {
  /// The player's current horizontal position.
  double _x = 0;

  /// The player's current vertical position.
  double _y = 0;

  /// The player's current velocity.
  Vector2 _velocity = Vector2.zero();

  /// The player's maximum jump height.
  static const double _maxJumpHeight = 200;

  /// The player's jump velocity.
  static const double _jumpVelocity = -800;

  /// The player's gravity acceleration.
  static const double _gravity = 2000;

  /// The player's health.
  int _health = 3;

  /// The player's invulnerability frames after taking damage.
  int _invulnerabilityFrames = 0;

  /// Constructs a new [Player] instance.
  Player() : super(size: Vector2(50, 80));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's sprite animation
    final spriteSheet = await gameRef.loadSpriteSheet(
      'player.png',
      srcSize: Vector2(50, 80),
      cols: 4,
      rows: 3,
    );
    animation = spriteSheet.createAnimation(row: 0, cols: 4, stepTime: 0.1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position based on velocity and gravity
    _x += _velocity.x * dt;
    _y += _velocity.y * dt;
    _velocity.y += _gravity * dt;

    // Clamp the player's position to the screen bounds
    _x = _x.clamp(0, gameRef.size.x - width);
    _y = _y.clamp(0, gameRef.size.y - height);

    // Decrement the invulnerability frames
    if (_invulnerabilityFrames > 0) {
      _invulnerabilityFrames--;
    }
  }

  @override
  void render(Canvas canvas) {
    // Render the player's sprite animation
    if (_invulnerabilityFrames > 0 && (_invulnerabilityFrames % 4) < 2) {
      // Blink the player during invulnerability frames
      return;
    }
    super.render(canvas);
  }

  /// Handles the player's jump input.
  void jump() {
    // Only allow the player to jump if they are on the ground
    if (_velocity.y == 0) {
      _velocity.y = _jumpVelocity;
    }
  }

  /// Handles the player's collision with an obstacle.
  void collideWithObstacle(Obstacle obstacle) {
    // Reduce the player's health and set invulnerability frames
    _health--;
    _invulnerabilityFrames = 60;
  }

  /// Handles the player's collision with a collectable.
  void collectCollectable(Collectable collectable) {
    // Increase the player's score or collect the item
    gameRef.score++;
    collectable.collected = true;
  }

  /// Returns the player's current health.
  int get health => _health;
}