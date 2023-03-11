import 'package:bacum/src/models/floor_size.dart';
import 'package:bacum/src/models/vacuum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VacuumProvider extends StateNotifier<Vacuum> {
  VacuumProvider(Vacuum value) : super(value);

  void setVelocity(double velocity) {
    state = state.copyWith(velocity: velocity);
  }

  void addPosition(int col, int row) {
    state = state.copyWith(col: state.col + col, row: state.row + row);
  }

  void move(int newRow, int newCol) {
    state = state.copyWith(row: newRow, col: newCol);
  }

  void validatePosition(FloorSize size) {
    if (state.row < 0) {
      state = state.copyWith(row: 0);
    } else if (state.row >= size.rows) {
      state = state.copyWith(row: size.rows - 1);
    }

    if (state.col < 0) {
      state = state.copyWith(col: 0);
    } else if (state.col >= size.cols) {
      state = state.copyWith(col: size.cols - 1);
    }
  }
}
