import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'dart:async' as async;

class PlayerInterface extends StatefulWidget {
  static const overlayKey = 'playerInterface';

  final BonfireGame game;
  const PlayerInterface({Key? key, required this.game}) : super(key: key);

  @override
  _PlayerInterfaceState createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  double life = 0;

  final double widthMax = 100;
  double widthCurrent = 100;

  late async.Timer _lifeTime;
  @override
  void initState() {
    _lifeTime = async.Timer.periodic(
      const Duration(milliseconds: 100),
      _verifyLife,
    );
    super.initState();
  }

  @override
  void dispose() {
    _lifeTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: widthCurrent,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                width: widthMax,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _verifyLife(async.Timer timer) {
    if (life != (widget.game.player?.life ?? 0)) {
      setState(() {
        life = widget.game.player?.life ?? 0;

        final percent = life / (widget.game.player?.maxLife ?? 0);
        widthCurrent = widthMax * percent;
      });
    }
  }
}
