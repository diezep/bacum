import 'package:bacum/src/models/floor.dart';
import 'package:bacum/src/models/game_settings.dart';
import 'package:bacum/src/models/vacuum.dart';
import 'package:bacum/src/models/vacuum_step.dart';

class BacuumGame {
  Floor floor;
  Vacuum vacuum;
  GameSettings settings;
  List<VacuumStep> steps = [];

  int get rows => settings.rows;
  int get cols => settings.cols;

  BacuumGame({
    required this.floor,
    required this.vacuum,
    required this.settings,
    this.steps = const [],
  });
}
