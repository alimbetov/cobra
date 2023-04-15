import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String MillisecondsText = "";
  Timer? waitingTimer;
  Timer? stopAbleTimer;
  GameSate gameSate = GameSate.readyStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment(0, -0.9),
            child: Text(
              "Test your reaction speed",
              textAlign: TextAlign.center,

              style: TextStyle(
                  fontSize: 38,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                  color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: Colors.grey,
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    MillisecondsText,
                    style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameSate) {
                  case GameSate.readyStart:
                    MillisecondsText="";
                    gameSate = GameSate.waiting;
                    _startWaitingTimer();
                    break;
                  case GameSate.waiting:
                    break;
                  case GameSate.canbeStopped:
                    gameSate = GameSate.readyStart;
                    stopAbleTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: _getGameSateColor(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameSate) {
      case GameSate.readyStart:
        return "START";
      case GameSate.waiting:
        return "WAIT";
      case GameSate.canbeStopped:
        return "STOP";
    }
  }
  Color _getGameSateColor() {
    switch (gameSate) {
      case GameSate.readyStart:
        return Color(0xFF40CA88);
      case GameSate.waiting:
        return Color(0xFFE0982D);
      case GameSate.canbeStopped:
        return Color(0xFFE02D47);
    }
  }
  void _startWaitingTimer() {
    final int randomMiliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMiliseconds), () {
      setState(() {
        gameSate = GameSate.canbeStopped;
      });
      _startStopAbleTiomer();
    });
  }

  void _startStopAbleTiomer() {
    stopAbleTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        MillisecondsText = "${timer.tick * 16} ms";
      });

    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stopAbleTimer?.cancel();
    super.dispose();
  }
}

enum GameSate { readyStart, waiting, canbeStopped }
