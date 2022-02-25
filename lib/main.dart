import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_island/decotarions/chess.dart';
import 'package:game_island/decotarions/lamp.dart';
import 'package:game_island/decotarions/mushroom.dart';
import 'package:game_island/game.dart';
import 'package:game_island/pages/home_page.dart';
import 'package:game_island/player/game_hero.dart';
import 'package:game_island/interface/player_interface.dart';
import 'package:game_island/util/fade_page_transition.dart';
import 'package:game_island/util/my_game_controller.dart';
import 'package:game_island/enemies/orc.dart';

const double tileSize = 16;

const double defaultZoom = 2.5;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.macOS: FadePageTransition(),
          },
        ),
      ),
      home: const HomePage(),
    );
  }
}
