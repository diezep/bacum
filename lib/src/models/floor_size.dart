class FloorSize {
  int rows;
  int cols;
  String? name;

  @override
  String toString() => name ?? '$rows x $cols';

  FloorSize({
    required this.rows,
    required this.cols,
    this.name,
  });
}
