import 'package:bonfire/bonfire.dart';
import 'package:game_island/decotarions/mushroom.dart';
import 'package:game_island/main.dart';
import 'package:game_island/player/game_hero.dart';
import 'package:game_island/sprite_sheets/decoration_sprite_sheet.dart';

class Chess extends GameDecoration with TapGesture, Vision {
  bool _playerIsClose = false;

  Sprite? chess, chessOpen;

  Chess(Vector2 position)
      : super.withSprite(
          sprite: DecorationSpriteSheet.chess,
          position: position,
          size: Vector2(16, 32),
        );
  @override
  void update(double dt) {
    seeComponentType<GameHero>(
      observed: (player) {
        if (!_playerIsClose) {
          _playerIsClose = true;
        }
      },
      notObserved: () {
        _playerIsClose = false;
      },
      radiusVision: tileSize * 1.5,
    );
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (_playerIsClose) {
      sprite = chessOpen;
    } else {
      sprite = chess;
    }
    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox(
        size: Vector2(16, 16),
        position: Vector2(0, 16),
      ),
    );
    chess = await DecorationSpriteSheet.chess;
    chessOpen = await DecorationSpriteSheet.chessOpen;
    return super.onLoad();
  }

  @override
  void onTap() {
    if (_playerIsClose) {
      gameRef.add(Mushroom(center.translated(tileSize, 0)));
    }
  }
}
