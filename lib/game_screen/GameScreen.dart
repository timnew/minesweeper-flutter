import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineGrid.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Mine Sweeper'),
      ),
      body: MineFieldView(width: 10, height: 10, mineCount: 10));
}
