import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';
import 'package:minesweeper/game_screen/MineFieldView.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

   MineField _mineField;

  _GameScreenState() {
     _mineField = MineField(10, 10, 10, this.setState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Mine Sweeper'),
      ),
      body: MineFieldView(mineField: _mineField),
      persistentFooterButtons: <Widget>[
        FlatButton(child: Text("Reset"), onPressed: () {
          setState(() {
            _mineField.reset();
          });
        },),
        FlatButton(child: Icon(Icons.flag),
          textColor: _mineField.currentAction == Cell.flagAction
              ? Colors.blue
              : Colors.black,
          onPressed: () {
            setState(() {
              _mineField.currentAction = Cell.flagAction;
            });
          },),
        FlatButton(child: Icon(Icons.location_searching),
          textColor: _mineField.currentAction == Cell.revealAction
              ? Colors.blue
              : Colors.black,
          onPressed: () {
            setState(() {
              _mineField.currentAction = Cell.revealAction;
            });
          },),
        FlatButton(
          child: Icon(Icons.adb),
          textColor: _mineField.currentAction == Cell.evaluateAction ? Colors
              .blue : Colors.black,
          onPressed: () {
            setState(() {
              _mineField.currentAction = Cell.evaluateAction;
            });
          },)
      ]
  );
}
