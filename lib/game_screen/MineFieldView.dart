import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';

class MineFieldView extends StatelessWidget {
  final MineField mineField;

  MineFieldView({Key key, this.mineField}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: GridView.count(
            crossAxisCount: mineField.size.width, children: _renderChildren()),
      );

  List<Widget> _renderChildren() => mineField.cells
      .map((cell) => CellView(key: Key(cell.name), cell: cell))
      .toList(growable: false);
}

class CellView extends StatelessWidget {
  final Cell cell;

  CellView({Key key, this.cell}) : super(key: key);

  CellState get state => cell.state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case CellState.Concealed:
        return _render(_consealedBox,
            null
        );
      case CellState.Revealed:
        return _render(_revealedBox, _renderMineMarker());
      case CellState.Flagged:
        return _render(_consealedBox, _flagContent);
      case CellState.Exploded:
        return _render(_explodedBox, _mineContent);
      case CellState.WrongFlag:
        return _render(_explodedBox, _flagContent);
      default:
        throw StateError("Impossible State");
    }
  }

  Widget _renderMineMarker() {
    if (cell.minesNearBy == 0)
      return null;

    return Text(
      cell.minesNearBy.toString(),
      style: TextStyle(
          color: _minesCountColors[cell.minesNearBy],
          fontWeight: FontWeight.bold
      ),
    );
  }

  static List<Color> _minesCountColors = [
    Colors.transparent, // 0
    Colors.lightGreen, // 1
    Colors.amber, // 2
    Colors.orange, // 3
    Colors.deepOrange, // 4
    Colors.red, // 5
    Colors.pink, // 7
    Colors.pink[900] // 8
  ];

  Decoration _consealedBox = BoxDecoration(
      border: Border.all(color: Colors.blue),
      color: Colors.lightBlue[300].withAlpha(50));

  static Decoration _revealedBox = BoxDecoration(
      border: Border.all(color: Colors.lightGreen[400]),
      color: Colors.lightGreen[100].withAlpha(50));

  static Decoration _explodedBox = BoxDecoration(
      border: Border.all(color: Colors.red), color: Colors.red.withAlpha(50));

  static Widget _flagContent = Icon(Icons.flag, color: Colors.red[300]);

  static Widget _mineContent = Icon(Icons.settings,color: Colors.blueGrey[500]);

  Widget _render(Decoration border, Widget content) => GestureDetector(
      onTap: () {
        cell.act();
      },
      child: Container(
          width: 10,
          height: 10,
          decoration: border,
          child: Center(child: content)));


}
