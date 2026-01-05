import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the 'testLast-runner-05' game.
///
/// Displays the game title, play button, level select option, and settings button.
/// Also includes a simple background animation.
class MenuScene extends Component with TapCallbacks {
  final GameRef game;
  late final TextComponent _titleComponent;
  late final ButtonComponent _playButton;
  late final ButtonComponent _levelSelectButton;
  late final ButtonComponent _settingsButton;
  late final AnimationComponent _backgroundAnimation;

  MenuScene(this.game);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Title
    _titleComponent = TextComponent(
      text: 'testLast-runner-05',
      position: game.size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_titleComponent);

    // Play button
    _playButton = ButtonComponent(
      position: Vector2(game.size.x / 2, game.size.y * 0.6),
      size: Vector2(200, 60),
      anchor: Anchor.center,
      child: TextComponent(
        text: 'Play',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the game scene
      },
    );
    add(_playButton);

    // Level select button
    _levelSelectButton = ButtonComponent(
      position: Vector2(game.size.x / 2, game.size.y * 0.7),
      size: Vector2(200, 60),
      anchor: Anchor.center,
      child: TextComponent(
        text: 'Level Select',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        // Navigate to the level select scene
      },
    );
    add(_levelSelectButton);

    // Settings button
    _settingsButton = ButtonComponent(
      position: Vector2(game.size.x - 50, 50),
      size: Vector2(50, 50),
      anchor: Anchor.topRight,
      child: SpriteComponent(
        sprite: await Sprite.load('settings_icon.png'),
        size: Vector2.all(30),
      ),
      onPressed: () {
        // Navigate to the settings scene
      },
    );
    add(_settingsButton);

    // Background animation
    _backgroundAnimation = AnimationComponent(
      animation: await game.loadAnimation('background_animation.png', 8, 1),
      position: Vector2.zero(),
      size: game.size,
    );
    add(_backgroundAnimation);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _backgroundAnimation.update(dt);
  }
}