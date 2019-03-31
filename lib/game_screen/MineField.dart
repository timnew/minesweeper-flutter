import 'package:flutter/material.dart';

typedef void StateChangedNotifier(VoidCallback block);

class MineField {
  final Size size;
  final int mineCount;
  final List<Cell> cells;
  final StateChangedNotifier notifyChanged;

  CellAction currentAction = Cell.revealAction;

  MineField(this.size, this.mineCount, this.notifyChanged)
      : cells = List(size.area()) {
    reset();
  }

  void reset() {
    final layout = ""
        + "+........."
        + ".+........"
        + ".+........"
        + ".....++..."
        + ".....+...."
        + ".........."
        + ".......+.."
        + ".+.....+.."
        + "..+......."
        + "..........";

    int x = 0;
    int y = 0;

    for (int i = 0; i < cells.length; i++) {
      cells[i] = Cell(parent: this,
          position: Position(x, y),
          content: layout[i] == '+' ? CellContent.Mine : CellContent
              .None);

      if (++x == size.width) {
        y++;
        x = 0;
      }
    }
  }

  List<Cell> findNearByCells(Cell cell) =>
      cell.position
          .findPossibleNearByPositions()
          .where((p) => size.isValid(p))
          .map((p) => size.convertToIndex(p))
          .map((i) => cells[i])
          .toList(growable: false);
}

class Size {
  final int width;
  final int height;

  const Size(this.width, this.height);

  int area() => width * height;

  bool isValid(Position pos) =>
      pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height;

  int convertToIndex(Position pos) =>
      pos.y * width + pos.x;
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  String toString() => "[$x, $y]";

  Iterable<Position> findPossibleNearByPositions() sync* {
    yield Position(x - 1, y - 1);
    yield Position(x, y - 1);
    yield Position(x + 1, y - 1);
    yield Position(x - 1, y);
    yield Position(x + 1, y);
    yield Position(x - 1, y + 1);
    yield Position(x, y + 1);
    yield Position(x + 1, y + 1);
  }
}

class Cell {
  final MineField parent;

  final String name;

  final Position position;

  final CellContent content;

  CellState _state;

  CellState get state => _state;

  int _minesNearBy;

  int get minesNearBy => _minesNearBy;

  Cell({this.parent, this.position, this.content})
      : name = position.toString() {
    this._state = CellState.Concealed;
  }

  void act() {
    parent.currentAction(this);
  }

  void updateState(CellState newState) {
    parent.notifyChanged(() {
      this._state = newState;
    });
  }

  void flag() {
    switch (state) {
      case CellState.Concealed:
        updateState(CellState.Flagged);
        break;
      case CellState.Flagged:
        updateState(CellState.Concealed);
        break;
      default:
        break;
    }
  }

  void reveal() {
    if (state != CellState.Concealed)
      return;

    if (content == CellContent.Mine) {
      updateState(CellState.Exploded);
      return;
    }

    final nearByCells = parent.findNearByCells(this);

    _minesNearBy =
        nearByCells
            .map((c) => c.content == CellContent.Mine ? 1 : 0)
            .reduce((a, b) => a + b);

    updateState(CellState.Revealed);

    if (minesNearBy == 0) {
      nearByCells.forEach((f) {
        f.reveal();
      });
    }
  }

  void evaluate() {
    if (state != CellState.Revealed || minesNearBy == 0)
      return;


  }

  static final CellAction revealAction = (Cell cell) {
    cell.reveal();
  };

  static final CellAction flagAction = (Cell cell) {
    cell.flag();
  };

  static final CellAction evaluateAction = (Cell cell) {
    cell.evaluate();
  };
}

typedef void ChangeNotifier(VoidCallback block);

enum CellContent {
  None,
  Mine
}

enum CellState {
  Concealed,
  Revealed,
  Flagged,
  Exploded,
  WrongFlag,
}

typedef void CellAction(Cell cell);
