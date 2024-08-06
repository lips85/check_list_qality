import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:check_list_qality/models/tile_model.dart';
import 'package:check_list_qality/repositories/tile_repository.dart';
import 'package:check_list_qality/services/excel_service.dart';

class TileViewModel extends StateNotifier<Map<String, List<TileModel>>> {
  final TileRepository _tileRepository;

  TileViewModel(this._tileRepository) : super({});

  Future<void> fetchTiles() async {
    final tiles = await _tileRepository.fetchTiles();
    final groupedTiles = <String, List<TileModel>>{};

    for (var tile in tiles) {
      groupedTiles.putIfAbsent(tile.system, () => []);
      groupedTiles[tile.system]!.add(tile);
    }

    state = groupedTiles;
  }

  void toggleCounter(String system, int index) {
    state = {
      ...state,
      system: [
        for (int i = 0; i < state[system]!.length; i++)
          if (i == index)
            state[system]![i].copyWith(
              counter: state[system]![i].counter == 1
                  ? 0
                  : state[system]![i].counter + 0.5,
            )
          else
            state[system]![i]
      ],
    };
  }

  void markAsNA(String system, int index) {
    state = {
      ...state,
      system: [
        for (int i = 0; i < state[system]!.length; i++)
          if (i == index)
            state[system]![i].copyWith(isNA: !state[system]![i].isNA)
          else
            state[system]![i]
      ],
    };
  }
}

final tileViewModelProvider =
    StateNotifierProvider<TileViewModel, Map<String, List<TileModel>>>((ref) {
  final excelService = ExcelService();
  final repository = TileRepository(excelService);
  return TileViewModel(repository);
});
