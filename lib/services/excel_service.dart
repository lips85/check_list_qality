import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:excel/excel.dart';

class ExcelService {
  Future<List<List<dynamic>>> loadExcelData() async {
    // 엑셀 파일을 assets에서 불러오기
    ByteData data = await rootBundle.load('assets/excel/checklist.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // 엑셀 파일을 파싱
    var excel = Excel.decodeBytes(bytes);

    var sheetLowData = <List<dynamic>>[];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet != null) {
        var sheetData = <dynamic>[];
        sheetData.add(table);
        for (var row in sheet.rows) {
          for (var cell in row) {
            if (cell != null) {
              sheetData.add(cell.value);
            }
          }
        }
        sheetLowData.add(sheetData);
      }
    }

    // 필요한 부분만 슬라이싱
    sheetLowData = sheetLowData.sublist(0, 9);

    return sheetLowData;
  }
}
