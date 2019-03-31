import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';

class MineFieldView extends StatefulWidget {
  final int width;
  final int height;
  final int mineCount;

  MineFieldView(
      {@required this.width, @required this.height, @required this.mineCount})
      : assert(width > 0),
        assert(height > 0),
        assert(mineCount > 0);

  @override
  State<StatefulWidget> createState() =>
      _MineFieldViewState(MineField(width, height, mineCount));
}

class _MineFieldViewState extends State<MineFieldView> {
  final MineField mineField;

  _MineFieldViewState(this.mineField);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child:
        GridView.count(
            crossAxisCount: widget.width, children: _renderChildren()),
      );

  List<Widget> _renderChildren() =>
      mineField.cells
      .map((cell) => CellView(key: Key(cell.name), cell: cell))
      .toList(growable: false);
}

class CellView extends StatefulWidget {
  final Cell cell;

  CellView({Key key, @required this.cell}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CellViewState(this.cell);
}

class _CellViewState extends State<CellView> {

  final Cell cell;

  _CellViewState(this.cell) {
    cell.onChanged((VoidCallback block) {
      this.setState(block);
    });
  }

  CellState get state => cell.state;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case CellState.Concealed:
        return _render(
            _consealedBox, cell.content == CellContent.Mine ? Text("*") : null);
      case CellState.Revealed:
        return _render(_revealedBox, null); // TODO: show number if needed
      case CellState.Flagged:
        return _render(_consealedBox, _flagContent);
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

  Widget _render(Decoration border, Widget content) =>
      GestureDetector(
          onTap: () {
            cell.act(Cell.flagAction);
          },
          child: Container(
              width: 10,
              height: 10,
              decoration: border,
              child: Center(child: content))
      );
}
