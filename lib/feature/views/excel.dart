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

      // 첫 번째 시트의 데이터를 읽어오기
      for (var table in excel.tables.keys) {
        print('Sheet: $table'); // 시트 이름
        var sheet = excel.tables[table];
        if (sheet != null) {
          for (var row in sheet.rows) {
            print(row); // 각 행의 데이터를 출력
          }
        }
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
