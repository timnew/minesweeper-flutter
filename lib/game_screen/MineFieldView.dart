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
        return _render(_revealedBox,
            cell.minesNearBy > 0 ? Text("${cell.minesNearBy}") : null);
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

  static Decoration _consealedBox = BoxDecoration(
      border: Border.all(color: Colors.black), color: Colors.grey);

  static Decoration _revealedBox = BoxDecoration(
      border: Border.all(color: Colors.black), color: Colors.white);

  static Decoration _explodedBox = BoxDecoration(
      border: Border.all(color: Colors.red), color: Colors.red.withAlpha(50));

  static Widget _flagContent = Icon(Icons.flag);

  static Widget _mineContent = Icon(Icons.settings);

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
