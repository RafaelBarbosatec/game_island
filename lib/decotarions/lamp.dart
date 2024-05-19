import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_island/main.dart';

class Lamp extends GameDecoration  {
  Lamp(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(tileSize)
        ) {
    setupLighting(
      LightingConfig(
        radius: tileSize * 1.5,
        color: Colors.orange.withOpacity(0.3),
        withPulse: true,
        pulseVariation: 0.1,
      ),
    );
  }
}
