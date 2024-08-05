import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'dart:typed_data';

class ExcelReaderScreen extends StatefulWidget {
  const ExcelReaderScreen({super.key});

  @override
  State<ExcelReaderScreen> createState() => _ExcelReaderScreenState();
}

class _ExcelReaderScreenState extends State<ExcelReaderScreen> {
  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      // 엑셀 파일을 assets에서 불러오기
      ByteData data = await rootBundle.load('assets/excel/checklist.xlsx');
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // 엑셀 파일을 파싱
      var excel = Excel.decodeBytes(bytes);

      var allData = [];

      for (var table in excel.tables.keys) {
        print('Sheet: $table'); // 시트 이름
        var sheet = excel.tables[table];
        var sheetData = [];
        sheetData.add(table);
        if (sheet != null) {
          for (var row in sheet.rows) {
            for (var cell in row) {
              if (cell != null) {
                // print("cell: ${cell.value}"); // 각 셀의 데이터를 출력
                sheetData.add(cell.value);
              }
            }
          }
          allData.add(sheetData);
        }
      }

      allData = allData.sublist(0, 9);
      print(allData.length);
      List<List<List<String>>> allItems = [];
      for (var i = 0; i < allData.length; i++) {
        List<List<String>> items = [];
        List<String> itemsA = allData[i]
            .skip(1)
            .where((value) => allData[i].indexOf(value) % 3 == 1)
            .toList();
        List<String> itemsB = allData[i]
            .skip(1)
            .where((value) => allData[i].indexOf(value) % 3 == 2)
            .toList();
        List<String> itemsC = allData[i]
            .skip(1)
            .where((value) => allData[i].indexOf(value) % 3 == 0)
            .toList();
        items = [itemsA, itemsB, itemsC];
        allItems.add(items);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Reader'),
      ),
      body: const Center(
        child: Text('Check console for Excel data'),
      ),
    );
  }
}
