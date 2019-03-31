import 'package:flutter/material.dart';

typedef void StateChangedNotifier(VoidCallback block);

class MineField {
  final int width;
  final int height;
  final int mineCount;
  final List<Cell> cells;
  final StateChangedNotifier notifyChanged;

  CellAction currentAction = Cell.revealAction;

  MineField(this.width, this.height, this.mineCount, this.notifyChanged)
      : cells = List(width * height) {
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

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        final index = row * width + col;
        cells[index] =
            Cell(parent: this,
                x: col,
                y: row,
                content: layout[index] == '+' ? CellContent.Mine : CellContent
                    .None);
      }
    }
  }
}

class Cell {
  final MineField parent;

  final String name;

  final int x;

  final int y;

  final CellContent content;

  CellState _state;

  CellState get state => _state;

  int _minesNearBy;

  int get minesNearBy => _minesNearBy;

  Cell({this.parent, this.x, this.y, this.content}) : name = "($x, $y)" {
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

  static final CellAction revealAction = (Cell cell) {};

  static final CellAction flagAction = (Cell cell) {
    switch (cell.state) {
      case CellState.Concealed:
        cell.updateState(CellState.Flagged);
        break;
      case CellState.Flagged:
        cell.updateState(CellState.Concealed);
        break;
      default:
        break;
    }
  };

  static final CellAction evaluateAction = (Cell cell) {};
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
