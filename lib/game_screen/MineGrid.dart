import 'package:flutter/material.dart';

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
  State<StatefulWidget> createState() => MineField(width, height, mineCount);
}

class MineField extends State<MineFieldView> {
  int get width => widget.width;

  int get height => widget.height;

  int get mineCount => widget.mineCount;

  List<Cell> cells;

  MineField(int width, int height, int mineCount) {
    cells = List(width * height);

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        cells[row * width + col] = Cell(x: col, y: row, type: CellType.Blank);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child:
            GridView.count(crossAxisCount: width, children: _renderChildren()),
      );

  List<Widget> _renderChildren() => cells
      .map((cell) => CellView(key: Key(cell.name), cell: cell))
      .toList(growable: false);
}

class CellView extends StatelessWidget {
  final Cell cell;

  CellState get state => cell.state;

  CellView({Key key, @required this.cell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case CellState.Concealed:
        return _render(_consealedBox, Text("C"));
      case CellState.Revealed:
        return _render(_revealedBox, Text("R")); // TODO: show number if needed
      case CellState.Flagged:
        return _render(_consealedBox, _flagContent);
      case CellState.TriggeredByClick:
        return _render(_triggerdBox, _mineContent);
      case CellState.TriggeredByWrongFlag:
        return _render(_triggerdBox, _flagContent);
      default:
        throw StateError("Impossible State");
    }
  }

  static Decoration _consealedBox = BoxDecoration(
      border: Border.all(color: Colors.black), color: Colors.grey);

  static Decoration _revealedBox = BoxDecoration(
      border: Border.all(color: Colors.black), color: Colors.white);

  static Decoration _triggerdBox = BoxDecoration(
      border: Border.all(color: Colors.red), color: Colors.red.withAlpha(50));

  static Widget _flagContent = Icon(Icons.flag);

  static Widget _mineContent = Icon(Icons.settings);

  Widget _render(Decoration border, Widget content) => Container(
      width: 10, height: 10, decoration: border, child: Center(child: content));
}

class Cell {
  final String name;

  final int x;

  final int y;

  final CellType type;

  CellState _state;

  CellState get state => _state;

  int _minesNearBy;

  int get minesNearBy => _minesNearBy;

  Cell({this.x, this.y, this.type}) : name = "($x, $y)" {
    this._state = CellState.Concealed;
  }
}

enum CellType {
  Blank,
  Mine,
}

enum CellState {
  Concealed,
  Revealed,
  Flagged,
  TriggeredByClick,
  TriggeredByWrongFlag
}
