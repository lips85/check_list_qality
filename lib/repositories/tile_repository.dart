import 'package:check_list_qality/models/tile_model.dart';
import 'package:check_list_qality/services/excel_service.dart';

class TileRepository {
  final ExcelService _excelService;

  TileRepository(this._excelService);

  Future<List<TileModel>> fetchTiles() async {
    final sheetLowData = await _excelService.loadExcelData();
    List<TileModel> tiles = [];

    for (var i = 0; i < sheetLowData.length; i++) {
      var sheetData = sheetLowData[i];
      var system = sheetData[0].toString();
      List<String> itemsA = sheetData
          .skip(1)
          .where((value) => sheetData.indexOf(value) % 3 == 1)
          .map<String>((value) => value.toString())
          .toList();
      List<String> itemsB = sheetData
          .skip(1)
          .where((value) => sheetData.indexOf(value) % 3 == 2)
          .map<String>((value) => value.toString())
          .toList();
      List<num> itemsC = sheetData
          .skip(1)
          .where((value) => sheetData.indexOf(value) % 3 == 0)
          .map<num>((value) => value.value)
          .toList();

      for (var j = 0; j < itemsA.length; j++) {
        tiles.add(TileModel(
          frontText: itemsA[j],
          backText: j < itemsB.length ? itemsB[j] : '',
          points: j < itemsC.length ? itemsC[j] : 0,
          system: system,
        ));
      }
    }

    return tiles;
  }
}
