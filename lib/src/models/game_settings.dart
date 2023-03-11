import 'package:bacum/src/models/floor.dart';
import 'package:bacum/src/models/floor_size.dart';

class GameSettings {
  FloorSize size;
  double tileSize;
  double tileMargin;
  double tileRadius;

  int get rows => size.rows;
  int get cols => size.cols;

  GameSettings({
    required this.size,
    this.tileSize = 30,
    this.tileMargin = 5,
    this.tileRadius = 10,
  });

  GameSettings copyWith({
    FloorSize? size,
    double? tileSize,
    double? tileMargin,
    double? tileRadius,
    Floor? floor,
  }) {
    return GameSettings(
      size: size ?? this.size,
      tileSize: tileSize ?? this.tileSize,
      tileMargin: tileMargin ?? this.tileMargin,
      tileRadius: tileRadius ?? this.tileRadius,
    );
  }
}
