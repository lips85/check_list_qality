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
      groupedTiles.putIfAbsent(tile.check, () => []);
      groupedTiles[tile.check]!.add(tile);
    }

    state = groupedTiles;
  }

  void toggleCounter(String check, int index) {
    state = {
      ...state,
      check: [
        for (int i = 0; i < state[check]!.length; i++)
          if (i == index)
            state[check]![i].copyWith(
              counter: state[check]![i].counter == 1
                  ? 0
                  : state[check]![i].counter + 0.5,
            )
          else
            state[check]![i]
      ],
    };
  }

  void clickCounter(String check, int index, double point) {
    state = {
      ...state,
      check: [
        for (int i = 0; i < state[check]!.length; i++)
          if (i == index)
            state[check]![i].copyWith(counter: point)
          else
            state[check]![i]
      ],
    };
  }

  void markAsNA(String check, int index) {
    state = {
      ...state,
      check: [
        for (int i = 0; i < state[check]!.length; i++)
          if (i == index)
            state[check]![i].copyWith(isNA: !state[check]![i].isNA, counter: 0)
          else
            state[check]![i]
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
