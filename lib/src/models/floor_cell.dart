class FloorCell {
  final int row, col;

  bool isWall;
  DirtyLevel dirty = DirtyLevel.clean;

  FloorCell(
    this.row,
    this.col, {
    this.isWall = false,
    this.dirty = DirtyLevel.clean,
  });
}

enum DirtyLevel {
  clean,
  dirty,
}
