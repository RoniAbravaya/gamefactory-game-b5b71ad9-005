import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// A collectible item component for a runner game.
class Collectible extends SpriteComponent with CollisionCallbacks {
  final double scoreValue;
  final AudioPlayer _audioPlayer;

  Collectible({
    required Vector2 position,
    required this.scoreValue,
    required Sprite sprite,
    required this.size,
    AudioPlayer? audioPlayer,
  })  : _audioPlayer = audioPlayer ?? AudioPlayer(),
        super(
          position: position,
          size: size,
          sprite: sprite,
        ) {
    addEffect(RotateEffect.by(
      2 * pi,
      EffectController(
        duration: 2,
        infinite: true,
      ),
    ));
    addEffect(MoveEffect.by(
      Vector2(0, 0.5),
      EffectController(
        duration: 1,
        infinite: true,
        alternate: true,
      ),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      _audioPlayer.play(AssetSource('collect_sound.mp3'));
      other.score += scoreValue;
      removeFromParent();
    }
  }
}