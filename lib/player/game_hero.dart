import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_island/main.dart';
import 'package:game_island/sprite_sheets/player_sprite_sheet.dart';

class GameHero extends SimplePlayer with ObjectCollision, Lighting, TapGesture {
  bool canMove = true;

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

    setupLighting(
      LightingConfig(
        radius: tileSize * 1.5,
        color: Colors.transparent,
        blurBorder: tileSize * 1.5,
      ),
    );
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN &&
        (event.id == 1 || event.id == LogicalKeyboardKey.space.keyId)) {
      _executeAttack();
    }
    super.joystickAction(event);
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (canMove) {
      super.joystickChangeDirectional(event);
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
  void die() {
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
    super.die();
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, identify) {
    canMove = false;

    final recieveDamageAnimation = lastDirectionHorizontal == Direction.left
        ? PlayerSpriteSheet.recieveDamageLeft
        : PlayerSpriteSheet.recieveDamageRight;
    animation?.playOnce(
      recieveDamageAnimation,
      runToTheEnd: true,
      onFinish: () {
        canMove = true;
      },
    );
    super.receiveDamage(attacker, damage, identify);
  }

  @override
  void onTap() {
    // TalkDialog.show(context, [
    //   Say(
    //     text: [
    //       TextSpan(text: 'AJHGAH dsjhgds dkjashdjksa kdjashdasd'),
    //     ],
    //     person: SizedBox(
    //       height: 100,
    //       width: 100,
    //       child: PlayerSpriteSheet.heroIdleRight.asWidget(),
    //     ),
    //   ),
    //   Say(
    //     text: [
    //       TextSpan(text: 'AJHGAH dsjhgds dkjashdjksa kdjashdasd'),
    //     ],
    //     person: SizedBox(
    //       height: 100,
    //       width: 100,
    //       child: OrcSpriteSheet.idleRight.asWidget(),
    //     ),
    //     personSayDirection: PersonSayDirection.RIGHT,
    //   ),
    // ],);
    if (FollowerWidget.isVisible('identify')) {
      FollowerWidget.remove('identify');
    } else {
      FollowerWidget.show(
        identify: 'identify',
        context: context,
        target: this,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Icon(Icons.add),
                const Text('Olá'),
                ElevatedButton(
                  onPressed: () {
                    if (FollowerWidget.isVisible('identify')) {
                      FollowerWidget.remove('identify');
                    }
                  },
                  child: const Text('Ok'),
                )
              ],
            ),
          ),
        ),
        align: const Offset(10, 10),
      );
    }
  }
}
