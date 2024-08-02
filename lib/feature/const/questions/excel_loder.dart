import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExcelLoader {
  Future<Map<String, List<List<dynamic>>>> loadExcelData(
      String filePath) async {
    // 엑셀 파일을 읽어옵니다.
    ByteData data = await rootBundle.load(filePath);
    var bytes = data.buffer.asUint8List();

    // 엑셀 파일을 파싱합니다.
    var excel = Excel.decodeBytes(bytes);

    // 각 시트의 A열과 B열 데이터를 리스트로 저장합니다.
    Map<String, List<List<dynamic>>> sheetData = {};

    for (var sheetName in excel.tables.keys) {
      var sheet = excel.tables[sheetName];

      List<dynamic> aColumnData = [];
      List<dynamic> bColumnData = [];

      for (var row in sheet!.rows) {
        if (row.isNotEmpty) aColumnData.add(row[0]?.value); // A열 데이터
        if (row.length > 1) bColumnData.add(row[1]?.value); // B열 데이터
      }

      sheetData[sheetName] = [aColumnData, bColumnData];
    }

    return sheetData;
  }
}
