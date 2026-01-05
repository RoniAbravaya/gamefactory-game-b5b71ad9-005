import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-runner-05/player.dart';

/// Represents an obstacle in the runner game.
class Obstacle extends PositionComponent with Hitbox, Collidable {
  final Sprite _sprite;
  final double _speed;

  /// Creates a new instance of the Obstacle component.
  ///
  /// [sprite] The sprite to be used for the obstacle.
  /// [speed] The speed at which the obstacle moves.
  Obstacle(this._sprite, this._speed) : super(size: Vector2.all(50.0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    // Respawn the obstacle if it goes off-screen
    if (position.x < -size.x) {
      position.x = game.size.x + size.x;
      position.y = game.random.nextDouble() * (game.size.y - size.y);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      // Damage the player on collision
      other.takeDamage();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, position: position, size: size);
  }
}