import 'package:bacum/main.dart';
import 'package:bacum/src/models/floor.dart';
import 'package:bacum/src/models/floor_cell.dart';
import 'package:bacum/src/models/game.dart';
import 'package:bacum/src/models/game_settings.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BacuumGameWidget extends FlameGame
    with HasTappables, HasDraggables, HasHoverables, HasComponentRef {
  BacuumGameWidget(this.game, WidgetRef ref) {
    HasComponentRef.widgetRef = ref;
  }
  BacuumGame game;
  FloorComponent? floorComponent;
  @override
  void onMount() async {
    super.onMount();
    add(floorComponent = FloorComponent(
      position: Vector2.all(0),
      size: size,
      floor: game.floor,
      settings: game.settings,
    ));

    listen(settingsProvider, (p0, p1) {
      for (var element in children) {
        if (element is FloorComponent) {
          element.settings = p1;
        }
      }
    });
  }
}

class FloorComponent extends PositionComponent with HasComponentRef {
  FloorComponent({
    super.position,
    super.size,
    super.anchor = Anchor.center,
    required this.floor,
    required this.settings,
  });

  Floor floor;
  GameSettings settings;
  final _paint = Paint()..color = Colors.white;

  int _rows = 0;
  int _cols = 0;
  double _tileSize = 0;
  double _tileMargin = 0;
  Vector2 _vacuumPosition = Vector2.zero();
  List<List<FloorTileComponent>> _tiles = [];

  List<List<FloorTileComponent>> generateTiles() {
    _rows = settings.rows;
    _cols = settings.cols;
    _tileSize = settings.tileSize;
    _tileMargin = settings.tileMargin;
    double tileSize = _tileMargin + _tileSize;

    var vacuum = ref.read(vacuumProvider);
    _vacuumPosition = Vector2(vacuum.col.toDouble(), vacuum.row.toDouble());
    var cells = ref.read(floorProvider).cells;

    return List.generate(
      _rows,
      (i) => List.generate(
        _cols,
        (j) => FloorTileComponent(
          position: Vector2(
            (j * tileSize) + (tileSize / 2) + size.x - (_cols * tileSize) / 2,
            (i * tileSize) + (tileSize / 2) + size.y - (_rows * tileSize) / 2,
          ),
          size: Vector2.all(_tileSize),
          tile: cells[i][j],
          hasVacuum: i == _vacuumPosition.y && j == _vacuumPosition.x,
          floorSize: size,
        ),
      ),
    );
  }

  @override
  void onMount() {
    super.onMount();
    var _settings = ref.read(settingsProvider);
    settings = _settings;

    var _floor = ref.read(floorProvider);
    floor = _floor;

    _tiles = generateTiles();
    addAll(_tiles.expand((element) => element).toList());

    listen(settingsProvider, (p0, settings) {
      removeAll(_tiles.expand((element) => element).toList());

      settings = settings;
      _tiles = generateTiles();
      addAll(_tiles.expand((element) => element).toList());
    });
  }
}

class FloorTileComponent extends PositionComponent
    with Tappable, Hoverable, Draggable, HasComponentRef {
  FloorTileComponent({
    super.position,
    super.size,
    super.anchor = Anchor.center,
    required this.floorSize,
    required this.tile,
    this.hasVacuum = false,
  });
  Vector2 floorSize;
  FloorCell tile;
  bool hasVacuum;
  Paint _paint = Paint()..color = Colors.white;
  Paint _dirtyPaint = Paint()..color = Colors.brown;
  Paint _vacuumPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;

  @override
  void onMount() {
    listen(vacuumProvider, (oldVacuum, vacuum) {
      if (tile.row == vacuum.row && tile.col == vacuum.col) {
        hasVacuum = true;
      } else {
        hasVacuum = false;
      }
    });
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);

    if (tile.dirty != DirtyLevel.clean) {
      canvas.drawRect((size).toRect().deflate(size.x / 3), _dirtyPaint);
    }
    if (hasVacuum) {
      canvas.drawRect(size.toRect().deflate(size.x), _vacuumPaint);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    tile.dirty =
        DirtyLevel.values[(tile.dirty.index + 1) % DirtyLevel.values.length];
    return super.onTapDown(info);
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    _paint.color = Colors.grey.shade300;
    return super.onHoverEnter(info);
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    _paint.color = Colors.white;
    return super.onHoverLeave(info);
  }

  Vector2? _dragStart;
  @override
  bool onDragStart(DragStartInfo info) {
    if (hasVacuum) _dragStart = info.eventPosition.game;

    return super.onDragStart(info);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (_dragStart == null) return super.onDragUpdate(info);
    var delta = info.eventPosition.game - _dragStart!;

    if ((delta.x ~/ size.x).abs() > 0 || (delta.y ~/ size.y).abs() > 0) {
      var newRow = tile.row + (delta.y / size.y);
      var newCol = tile.col + (delta.x / size.x);

      ref.read(vacuumProvider.notifier).move(newRow.round(), newCol.round());
    }
    return super.onDragUpdate(info);
  }
}

Vector2 calculateTilePosition(
    Vector2 mouse, Vector2 tileSize, Vector2 floorSize) {
  int _cols = floorSize.x ~/ (tileSize.x + 5);
  int _rows = floorSize.y ~/ (tileSize.y + 5);

  // (j * tileSize) + (tileSize / 2) + size.x - (_cols * tileSize) / 2,
  // (i * tileSize) + (tileSize / 2) + size.y - (_rows * tileSize) / 2,
  var x = (mouse.x - floorSize.x / 2) / tileSize.x;
  var y = (mouse.y - floorSize.y / 2) / tileSize.y;
  return Vector2(x, y);
}
