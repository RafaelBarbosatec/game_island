import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:game_island/main.dart';
import 'package:game_island/sprite_sheets/orc_sprite_sheet.dart';
import 'package:game_island/sprite_sheets/player_sprite_sheet.dart';

class Orc extends SimpleEnemy with ObjectCollision, AutomaticRandomMovement {
  bool canMove = true;

  Orc(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(tileSize),
          speed: 20,
          animation: SimpleDirectionAnimation(
            idleRight: OrcSpriteSheet.idleRight,
            runRight: OrcSpriteSheet.runRight,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(8, 5),
            align: Vector2(4, 11),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    if (canMove) {
      seePlayer(
        observed: (player) {
          seeAndMoveToPlayer(
            closePlayer: (player) {
              _executeAttack();
            },
            radiusVision: tileSize * 2,
            margin: 4,
          );
        },
        notObserved: () {
          runRandomMovement(dt);
        },
        radiusVision: tileSize * 2,
      );
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(
      canvas,
      borderWidth: 2,
      height: 2,
      align: const Offset(0, -5),
    );
    super.render(canvas);
  }

  @override
  void die() {
    final dieAnimation = lastDirectionHorizontal == Direction.left
        ? OrcSpriteSheet.dieLeft
        : OrcSpriteSheet.dieRight;
    animation?.playOnce(
      dieAnimation,
      runToTheEnd: true,
      onFinish: () {
        removeFromParent();
      },
    );
    super.die();
  }

  @override
  void receiveDamage(double damage, from) {
    canMove = false;
    final receiveDamageAnimation = lastDirectionHorizontal == Direction.left
        ? OrcSpriteSheet.recieveDamageLeft
        : OrcSpriteSheet.recieveDamageRight;
    animation?.playOnce(
      receiveDamageAnimation,
      runToTheEnd: true,
      onFinish: () {
        canMove = true;
      },
    );

    super.receiveDamage(damage, from);
  }

  void _executeAttack() {
    simpleAttackMelee(
      damage: 20,
      sizePush: tileSize * 0.5,
      animationLeft: PlayerSpriteSheet.attackLeft,
      animationDown: PlayerSpriteSheet.attackBottom,
      animationRight: PlayerSpriteSheet.attackRight,
      animationUp: PlayerSpriteSheet.attackTop,
      size: Vector2.all(tileSize * 0.8),
    );
  }
}
