import 'package:check_list_qality/feature/const/questions/questions.dart';
import 'package:check_list_qality/feature/models/tile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileViewModel extends StateNotifier<List<TileModel>> {
  TileViewModel(List<List<List<String>>> itemsAll)
      : super(List.generate(itemsAll[0][0].length, (_) => TileModel()));

  void toggleSelected(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index && !state[i].isNA)
          TileModel(
            isSelected: !state[i].isSelected,
            isNA: state[i].isNA,
            counter: state[i].isSelected ? state[i].counter : state[i].counter,
          )
        else
          state[i]
    ];
  }

  void incrementCounter(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index && !state[i].isNA)
          TileModel(
            isSelected: state[i].isSelected,
            isNA: state[i].isNA,
            counter: (state[i].counter + 1) % 4,
          )
        else
          state[i]
    ];
  }

  void markAsNA(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          TileModel(
            isSelected: false,
            isNA: !state[i].isNA,
            counter: 0,
          )
        else
          state[i]
    ];
  }
}

final tileViewModelProvider =
    StateNotifierProvider<TileViewModel, List<TileModel>>((ref) {
  final itemsAll = ref.read(itemsAllProvider);
  return TileViewModel(itemsAll);
});

final itemsAllProvider = Provider<List<List<List<String>>>>((ref) {
  return itemsAll;
});
