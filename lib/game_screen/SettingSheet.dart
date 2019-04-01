import 'package:flutter/material.dart';
import 'package:minesweeper/game_screen/MineField.dart';

class MineFieldSettings {
  int _width;

  int get width => _width;

  set width(value) {
    _width = value;
    _update();
  }

  int _height;

  int get height => _height;

  set height(value) {
    _height = value;
    _update();
  }

  int _mineCount;

  set mineCount(value) {
    _mineCount = value;
  }

  int get mineCount => _mineCount;

  int _maxMineCount;
  int _mineCountDivisions;

  void _update() {
    final area = width * height;
    final factor = (area / 20).round();

    _maxMineCount = factor * 10;
    _mineCountDivisions = factor + 1;

    if (mineCount > maxMineCount) mineCount = maxMineCount;
  }

  int get maxMineCount => _maxMineCount;

  int get mineCountDivisions => _mineCountDivisions;

  MineFieldSettings(int width, int height, int mineCount) {
    this._width = width;
    this._height = height;
    this._mineCount = mineCount;
    _update();
  }

  MineField createMineField(StateChangedNotifier notifyChanged) =>
      MineField(Size(width, height), mineCount, notifyChanged);
}

class SettingSheet extends StatefulWidget {
  final MineFieldSettings settings;

  SettingSheet({Key key, this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingSheetState(settings);
}

class _SettingSheetState extends State<SettingSheet> {
  MineFieldSettings settings;

  _SettingSheetState(this.settings);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Slider(
            label: "Width: ${settings.width}",
            value: settings.width.toDouble(),
            min: 10,
            max: 18,
            divisions: 9,
            onChanged: (value) {
              setState(() {
                settings.width = value.round();
              });
            },
          ),
          Slider(
            label: "Height: ${settings.height}",
            value: settings.height.toDouble(),
            min: 10,
            max: 80,
            divisions: 9,
            onChanged: (value) {
              setState(() {
                settings.height = value.round();
              });
            },
          ),
          Slider(
            label: "Mine Count: ${settings.mineCount}",
            value: settings.mineCount.toDouble(),
            min: 10,
            max: settings.maxMineCount.toDouble(),
            divisions: settings.mineCountDivisions,
            onChanged: (value) {
              setState(() {
                settings.mineCount = value.round();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text("Apply"),
            onTap: () {
              Navigator.pop(context, settings);
            },
          ),
          ListTile(
              leading: Icon(Icons.cancel),
              title: Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              })
        ],
      );
}
