import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_island/main.dart';
import 'package:game_island/sprite_sheets/player_sprite_sheet.dart';

class GameHero extends SimplePlayer with BlockMovementCollision, Lighting {
  bool _canMove = true;

  GameHero(Vector2 position)
      : super(
          position: position,
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.heroIdleRight,
            runRight: PlayerSpriteSheet.heroRunRight,
          ),
          speed: 50,
          size: Vector2.all(tileSize),
        ) {
    setupLighting(
      LightingConfig(
        radius: tileSize * 1.5,
        color: Colors.transparent,
        blurBorder: tileSize * 1.5,
      ),
    );
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN &&
        (event.id == 1 || event.id == LogicalKeyboardKey.space)) {
      _executeAttack();
    }
    super.onJoystickAction(event);
  }

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (_canMove) {
      super.onJoystickChangeDirectional(event);
    }
  }

  void _executeAttack() {
    simpleAttackMelee(
      damage: 20,
      sizePush: tileSize * 0.5,
      animationRight: PlayerSpriteSheet.attackRight,
      size: Vector2.all(tileSize * 0.8),
    );
  }

  @override
  void onDie() {
    final dieAnimation = lastDirectionHorizontal == Direction.left
        ? PlayerSpriteSheet.dieLeft
        : PlayerSpriteSheet.dieRight;
    animation?.playOnce(
      dieAnimation,
      runToTheEnd: true,
      onFinish: () {
        removeFromParent();
      },
    );
    super.onDie();
  }

  @override
  void onRemoveLife(double life) {
    _canMove = false;
    stopMove();

    final recieveDamageAnimation = lastDirectionHorizontal == Direction.left
        ? PlayerSpriteSheet.recieveDamageLeft
        : PlayerSpriteSheet.recieveDamageRight;
    animation?.playOnce(
      recieveDamageAnimation,
      runToTheEnd: true,
      onFinish: () {
        _canMove = true;
      },
    );
    super.onRemoveLife(life);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(8, 5),
        position: Vector2(4, 11),
      ),
    );
    return super.onLoad();
  }
}
