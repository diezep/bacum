import 'package:bacum/src/models/floor_cell.dart';
import 'package:bacum/src/models/floor_size.dart';

class Floor {
  final List<List<FloorCell>> cells;

  Floor(FloorSize size) : cells = generateCells(size);

  static List<List<FloorCell>> generateCells(FloorSize size) {
    return List.generate(
      size.rows,
      (row) => List.generate(
        size.cols,
        (col) => FloorCell(
          row,
          col,
          isWall: row == 0 ||
              row == size.rows - 1 ||
              col == 0 ||
              col == size.cols - 1,
        ),
      ),
    );
  }
}
