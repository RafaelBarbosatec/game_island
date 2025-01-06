import 'package:bonfire/bonfire.dart';
import 'package:game_island/main.dart';
import 'package:game_island/sprite_sheets/orc_sprite_sheet.dart';
import 'package:game_island/sprite_sheets/player_sprite_sheet.dart';

class Orc extends SimpleEnemy
    with BlockMovementCollision, RandomMovement, UseLifeBar {
  bool _canMove = true;

  Orc(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(tileSize),
          speed: 20,
          animation: SimpleDirectionAnimation(
            idleRight: OrcSpriteSheet.idleRight,
            runRight: OrcSpriteSheet.runRight,
          ),
        );

  @override
  void update(double dt) {
    if (_canMove) {
      seeAndMoveToPlayer(
        closePlayer: (player) {
          _executeAttack();
        },
        radiusVision: tileSize * 2,
        margin: 4,
        notObserved: () {
          runRandomMovement(dt);
          return false;
        },
      );
    }

    super.update(dt);
  }

  @override
  void onDie() {
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
    super.onDie();
  }

  @override
  void onRemoveLife(double life) {
    _canMove = false;
    stopMove();
    final receiveDamageAnimation = lastDirectionHorizontal == Direction.left
        ? OrcSpriteSheet.recieveDamageLeft
        : OrcSpriteSheet.recieveDamageRight;
    animation?.playOnce(
      receiveDamageAnimation,
      runToTheEnd: true,
      onFinish: () {
        _canMove = true;
      },
    );
    super.onRemoveLife(life);
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
