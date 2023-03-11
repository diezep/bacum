import 'package:bacum/src/models/floor.dart';
import 'package:bacum/src/models/floor_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloorProvider extends StateNotifier<Floor> {
  FloorProvider(Floor value) : super(value);

  void setSize(FloorSize size) {
    state = Floor(size);
  }
}
