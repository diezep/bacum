import 'package:bacum/src/models/game.dart';
import 'package:bacum/src/models/vacuum_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameProvider extends StateNotifier<BacuumGame> {
  GameProvider(BacuumGame value) : super(value);

  addStep(VacuumStep step) {
    state.steps.add(step);
  }
}
