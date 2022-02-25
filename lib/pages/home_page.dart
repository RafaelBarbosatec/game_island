import 'package:flutter/material.dart';
import 'package:game_island/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
                return const Game();
              }),
              (route) => false,
            );
          },
          child: Text('INICIAR'),
        ),
      ),
    );
  }
}
