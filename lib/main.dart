import 'package:bacum/src/game/engine.dart';
import 'package:bacum/src/models/floor.dart';
import 'package:bacum/src/models/floor_size.dart';
import 'package:bacum/src/models/game.dart';
import 'package:bacum/src/models/game_settings.dart';
import 'package:bacum/src/models/vacuum.dart';
import 'package:bacum/src/models/vacuum_step.dart';
import 'package:bacum/src/providers/floor_provider.dart';
import 'package:bacum/src/providers/game_provider.dart';
import 'package:bacum/src/providers/settings_provider.dart';
import 'package:bacum/src/providers/vacuum_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
final floorProvider = StateNotifierProvider<FloorProvider, Floor>((ref) {
  var settings = ref.watch(settingsProvider);
  return FloorProvider(Floor(settings.size));
});

final vacuumProvider = StateNotifierProvider<VacuumProvider, Vacuum>(
    (ref) => VacuumProvider(Vacuum()));

final settingsProvider = StateNotifierProvider<SettingsProvider, GameSettings>(
    (ref) => SettingsProvider(GameSettings(size: sizes[0]), ref));

final gameProvider = StateNotifierProvider<GameProvider, BacuumGame>(
  (ref) => GameProvider(BacuumGame(
    vacuum: ref.watch(vacuumProvider),
    floor: ref.watch(floorProvider),
    settings: ref.watch(settingsProvider),
  )),
);

List<FloorSize> sizes = [
  FloorSize(rows: 1, cols: 2),
  FloorSize(rows: 2, cols: 2),
  FloorSize(rows: 3, cols: 3),
  FloorSize(rows: 4, cols: 4),
  FloorSize(rows: 5, cols: 5),
  FloorSize(rows: 10, cols: 10),
  FloorSize(rows: 15, cols: 15),
  FloorSize(rows: 20, cols: 20),
];

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          Size screenSize = Size(constraints.maxWidth, constraints.maxHeight);

          final game = ref.read(gameProvider);

          if (screenSize.width < 450) {
            return GameWidget(
              game: BacuumGameWidget(game, ref),
            );
          }

          return Row(children: [
            Container(
              width: 450,
              child: ConfigurationsGame(),
            ),
            Expanded(
              child: GameWidget(
                mouseCursor: MouseCursor.defer,
                game: BacuumGameWidget(game, ref),
              ),
            )
          ]);
        }),
      ),
    );
  }
}

class ConfigurationsGame extends ConsumerWidget {
  const ConfigurationsGame({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  child: Text(
                    'Configuraciones',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tamaño ', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: ref.watch(settingsProvider).tileSize,
                      max: 50,
                      divisions: 50,
                      onChanged: (v) {
                        ref.watch(settingsProvider.notifier).setTileSize(v);
                      },
                    ),
                    Text(
                      ref.watch(settingsProvider).tileSize.toStringAsFixed(2),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Margen ', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: ref.watch(settingsProvider).tileMargin,
                      max: 10,
                      divisions: 10,
                      onChanged: (v) {
                        ref.watch(settingsProvider.notifier).setTileMargin(v);
                      },
                    ),
                    Text(
                      ref.watch(settingsProvider).tileMargin.toStringAsFixed(2),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Aspiradora',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Velocidad', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: ref.watch(vacuumProvider).velocity,
                      max: 3,
                      divisions: 20,
                      onChanged: (v) {
                        ref.watch(vacuumProvider.notifier).setVelocity(v);
                      },
                    ),
                    Text(
                      ref.watch(vacuumProvider).velocity.toStringAsFixed(2),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Piso',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Matriz', style: TextStyle(fontSize: 18)),
                    Slider(
                      value: sizes
                          .indexOf(ref.watch(settingsProvider).size)
                          .toDouble(),
                      max: sizes.length.toDouble() - 1,
                      divisions: sizes.length - 1,
                      onChanged: (v) {
                        ref
                            .watch(settingsProvider.notifier)
                            .setSize(sizes[v.toInt()]);
                        ref
                            .watch(vacuumProvider.notifier)
                            .validatePosition(ref.read(settingsProvider).size);
                      },
                    ),
                    Text(
                      ref.watch(settingsProvider).size.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Secuencia de pasos: ',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Container(
                  height: 300,
                  color: Colors.white,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: ref.watch(gameProvider).steps.length,
                    itemBuilder: (context, index) {
                      VacuumStep step = ref.watch(gameProvider).steps[index];
                      return Text('${index + 1}. ${step.name}');
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Randomizar'),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Iniciar'),
            ),
          ),
        ],
      ),
    );
  }
}
