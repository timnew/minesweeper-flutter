import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';
import 'package:minesweeper/game_screen/MineGrid.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  MineFieldController _fieldController;
  MineField _mineField;

  _GameScreenState() {
    _fieldController = MineFieldController();
    _mineField = MineField(10, 10, 10, _fieldController);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Mine Sweeper'),
      ),
      body:
      Row(
        children: <Widget>[
          MineFieldView(mineField: _mineField,),
          RaisedButton(
            onPressed: () {
              setState(() {
                _fieldController.reset();
              });
            },
            child: Text("Reset"),
          )
        ],
      )
  );
}
