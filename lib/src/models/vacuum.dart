class Vacuum {
  bool isRunning;
  bool isPaused;
  int initialBattery;
  int currentBattery;
  int row;
  int col;
  double velocity;

  Vacuum({
    this.isRunning = false,
    this.isPaused = false,
    this.initialBattery = 100,
    this.currentBattery = 100,
    this.row = 0,
    this.col = 0,
    this.velocity = 1,
  });

  Vacuum copyWith({
    bool? isRunning,
    bool? isPaused,
    int? initialBattery,
    int? currentBattery,
    int? row,
    int? col,
    double? velocity,
  }) {
    return Vacuum(
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      initialBattery: initialBattery ?? this.initialBattery,
      currentBattery: currentBattery ?? this.currentBattery,
      row: row ?? this.row,
      col: col ?? this.col,
      velocity: velocity ?? this.velocity,
    );
  }
}
