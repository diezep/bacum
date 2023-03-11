import 'package:bacum/main.dart';
import 'package:bacum/src/models/floor_size.dart';
import 'package:bacum/src/models/game_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsProvider extends StateNotifier<GameSettings> {
  SettingsProvider(GameSettings value, this.ref) : super(value);

  final Ref ref;
  void setTileSize(double value) {
    state = state.copyWith(tileSize: value);
  }

  void setTileMargin(double value) {
    state = state.copyWith(tileMargin: value);
  }

  void setTileRadius(double value) {
    state = state.copyWith(tileRadius: value);
  }

  void setSize(FloorSize value) {
    ref.read(floorProvider.notifier).setSize(value);
    state = state.copyWith(size: value);
  }
}
