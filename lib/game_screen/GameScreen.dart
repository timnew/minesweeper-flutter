import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';
import 'package:minesweeper/game_screen/MineFieldView.dart';
import 'package:minesweeper/game_screen/SettingSheet.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

   MineField _mineField;

  _GameScreenState() {
    _mineField = MineField(Size(14, 50), 100, this.setState);
  }

   String _title() {
     switch (_mineField.gameResult) {
       case GameResult.Succeeded:
         return "You Win";
       case GameResult.Failed:
         return "You Lose";
       case GameResult.Undetermined:
         return "Mine Sweeper";
     }
   }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(_title()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.tune),
            tooltip: 'Settings',
            onPressed: () {
              _showSettings(context);
            },
          ),
        ],
      ),
      body: MineFieldView(mineField: _mineField),
      persistentFooterButtons: <Widget>[
        FlatButton(child: Icon(Icons.refresh), onPressed: () {
          setState(() {
            _mineField.reset();
          });
        },),
        FlatButton(child: Icon(Icons.flag),
          textColor: _mineField.currentAction == CellAction.Flag
              ? Colors.blue
              : Colors.black,
          onPressed: () {
            setState(() {
              _mineField.currentAction = CellAction.Flag;
            });
          },),
        FlatButton(child: Icon(Icons.location_searching),
          textColor: _mineField.currentAction == CellAction.Reveal
              ? Colors.blue
              : Colors.black,
          onPressed: () {
            setState(() {
              _mineField.currentAction = CellAction.Reveal;
            });
          },),
        FlatButton(
          child: Icon(Icons.adb),
          textColor: _mineField.currentAction == CellAction.Evaluate ? Colors
              .blue : _mineField.currentAction == CellAction.SuperEvaluate
              ? Colors.red
              : Colors.black,
          onPressed: () {
            setState(() {
              switch (_mineField.currentAction) {
                case CellAction.SuperEvaluate:
                  _mineField.currentAction = CellAction.Evaluate;
                  break;
                case CellAction.Evaluate:
                  _mineField.currentAction = CellAction.SuperEvaluate;
                  break;
                default:
                  _mineField.currentAction = CellAction.Evaluate;
                  break;
              }
            });
          },
        ),
        Text("B: ${_mineField.remainingCellCount} M: ${_mineField
            .remainingMineCount}")
      ]
  );

   void _showSettings(BuildContext context) async {
     final MineFieldSettings settings = await showModalBottomSheet(
         context: context,
         builder: (context) =>
             SettingSheet(
                 settings: MineFieldSettings(
                     _mineField.size.width,
                     _mineField.size.height,
                     _mineField.mineCount
                 )
             )
     );

     if (settings != null) {
       setState(() {
         this._mineField = settings.createMineField(this.setState);
       });
     }
   }

}
