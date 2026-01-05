import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the runner game.
class Player extends SpriteAnimationComponent with HasGameRef, Collidable {
  /// The player's current horizontal speed.
  double xSpeed = 200;

  /// The player's current vertical speed.
  double ySpeed = 0;

  /// The player's maximum jump height.
  double maxJumpHeight = 300;

  /// The player's current health/lives.
  int health = 3;

  /// The player's current score.
  int score = 0;

  /// The player's animation states.
  late SpriteAnimation idleAnimation;
  late SpriteAnimation runningAnimation;
  late SpriteAnimation jumpingAnimation;

  Player(Vector2 position, Vector2 size)
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's animation sprites
    final spriteSheet = await gameRef.loadSpriteSheet(
      'player.png',
      srcSize: Vector2(32, 32),
    );

    idleAnimation = spriteSheet.createAnimation(row: 0, cols: 4, stepTime: 0.2);
    runningAnimation = spriteSheet.createAnimation(row: 1, cols: 6, stepTime: 0.1);
    jumpingAnimation = spriteSheet.createAnimation(row: 2, cols: 2, stepTime: 0.5);

    // Set the initial animation
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position based on speed
    position.x += xSpeed * dt;
    position.y += ySpeed * dt;

    // Update the player's animation based on speed
    if (ySpeed != 0) {
      animation = jumpingAnimation;
    } else if (xSpeed != 0) {
      animation = runningAnimation;
    } else {
      animation = idleAnimation;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    // Handle collision with obstacles
    if (other is Obstacle) {
      health--;
      if (health <= 0) {
        // Player has died, end the game
        gameRef.pauseEngine();
      }
    }
  }

  /// Handles the player's jump input.
  void jump() {
    if (ySpeed == 0) {
      ySpeed = -maxJumpHeight;
    }
  }

  /// Increments the player's score.
  void incrementScore(int amount) {
    score += amount;
  }
}