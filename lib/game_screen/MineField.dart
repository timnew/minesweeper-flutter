import 'package:flutter/material.dart';

class MineFieldController {
  MineField mineField;

  void reset() {
    mineField.reset();
  }
}

class MineField {
  final int width;
  final int height;
  final int mineCount;
  final MineFieldController controller;
  final List<Cell> cells;

  MineField(this.width, this.height, this.mineCount,
      this.controller)
      : cells = List(width * height) {
    controller.mineField = this;
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

  ChangeNotifier _notifier;

  void act(CellAction action) {
    _notifier(() {
      _state = action(this);
    });
  }

  Cell({this.parent, this.x, this.y, this.content}) : name = "($x, $y)" {
    this._state = CellState.Concealed;
  }

  void onChanged(ChangeNotifier notifier) {
    _notifier = notifier;
  }

  static final CellAction revealAction = (Cell cell) {};

  static final CellAction flagAction = (Cell cell) {
    switch (cell.state) {
      case CellState.Concealed:
        return CellState.Flagged;
      case CellState.Flagged:
        return CellState.Concealed;
      default:
        return cell.state;
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
  Flagged
}

typedef CellState CellAction(Cell cell);
