import 'package:flutter/material.dart';

typedef void StateChangedNotifier(VoidCallback block);

class MineField {
  final Size size;
  final int mineCount;
  final List<Cell> cells;
  final StateChangedNotifier notifyChanged;

  GameResult _gameResult;

  GameResult get gameResult => _gameResult;

  int _remainingCellCount;

  int get remainingCellCount => _remainingCellCount;

  int _remainingMineCount;

  int get remainingMineCount => _remainingMineCount;

  CellAction currentAction;

  MineField(this.size, this.mineCount, this.notifyChanged)
      : cells = List(size.area()) {
    reset();
  }

  void reset() {
    _remainingMineCount = mineCount;
    _remainingCellCount = cells.length - mineCount;
    _gameResult = GameResult.Undetermined;
    currentAction = CellAction.Reveal;

    final layout = List<CellContent>(cells.length);
    for (int i = 0; i < layout.length; i++) {
      layout[i] = i < mineCount ? CellContent.Mine : CellContent.None;
    }

    layout.shuffle();

    int x = 0;
    int y = 0;

    for (int i = 0; i < cells.length; i++) {
      cells[i] = Cell(parent: this,
          position: Position(x, y),
          content: layout[i]);

      if (++x == size.width) {
        y++;
        x = 0;
      }
    }
  }

  void updateMineCount(int delta) {
    notifyChanged(() {
      _remainingMineCount += delta;
    });
  }

  void decreaseCellCount() {
    notifyChanged(() {
      if (--_remainingCellCount == 0) {
        endGame(GameResult.Succeeded);
      }
    });
  }

  List<Cell> findNearByCells(Cell cell) =>
      cell.position
          .findPossibleNearByPositions()
          .where((p) => size.isValid(p))
          .map((p) => size.convertToIndex(p))
          .map((i) => cells[i])
          .toList(growable: false);

  void endGame(GameResult result) {
    notifyChanged(() {
      _gameResult = result;
    });
  }
}

enum GameResult {
  Failed,
  Undetermined,
  Succeeded
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
    switch (parent.currentAction) {
      case CellAction.Reveal:
        this.reveal();
        break;
      case CellAction.Flag:
        this.flag();
        break;
      case CellAction.Evaluate:
        this.evaluate(false);
        break;
      case CellAction.SuperEvaluate:
        this.evaluate(true);
        break;
    }
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
        parent.updateMineCount(-1);
        break;
      case CellState.Flagged:
        updateState(CellState.Concealed);
        parent.updateMineCount(1);
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
      parent.endGame(GameResult.Failed);
      return;
    }

    final nearByCells = parent.findNearByCells(this);

    _minesNearBy =
        nearByCells
            .map((c) => c.content == CellContent.Mine ? 1 : 0)
            .reduce((a, b) => a + b);

    updateState(CellState.Revealed);

    parent.decreaseCellCount();

    if (minesNearBy == 0) {
      nearByCells.forEach((f) {
        f.reveal();
      });
    }
  }

  void evaluate(bool superMode) {
    if (state != CellState.Revealed || minesNearBy == 0)
      return;

    final nearByCells = parent.findNearByCells(this);

    final flagsNearBy = nearByCells
        .where((c) => c.state == CellState.Flagged)
        .length;

    if (flagsNearBy == minesNearBy) {
      nearByCells.forEach((c) => c.reveal());

      if (parent.gameResult == GameResult.Failed) {
        nearByCells
            .where((c) => c.state == CellState.Flagged)
            .where((c) => c.content != CellContent.Mine)
            .forEach((c) => c.updateState(CellState.WrongFlag));
      }
    }

    if (!superMode)
      return;

    final concealedOrFlaggedCount = nearByCells
        .where((c) =>
    (c.state == CellState.Flagged) ||
        (c.state == CellState.Concealed)
    )
        .length;

    if (concealedOrFlaggedCount != minesNearBy)
      return;

    nearByCells
        .where((c) => c.state == CellState.Concealed)
        .forEach((c) => c.flag());
  }
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


enum CellAction {
  Reveal,
  Flag,
  Evaluate,
  SuperEvaluate
}
