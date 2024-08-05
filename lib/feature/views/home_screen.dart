import 'package:check_list_qality/feature/view_models/tile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'dart:typed_data';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late List<List<List<String>>> items = [];
  late List<String> titles = [];

  @override
  void initState() {
    super.initState();

    _loadExcelData();
  }

  Future _loadExcelData() async {
    // 엑셀 파일을 assets에서 불러오기
    ByteData data = await rootBundle.load('assets/excel/checklist.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // 엑셀 파일을 파싱
    var excel = Excel.decodeBytes(bytes);

    var sheetLowData = [];

    for (var table in excel.tables.keys) {
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
        sheetLowData.add(sheetData);
      }
    }

    sheetLowData = sheetLowData.sublist(0, 9);

    for (var i = 0; i < sheetLowData.length; i++) {
      List<List<String>> item = [];
      List<String> itemsA = sheetLowData[i]
          .skip(1)
          .where((value) => sheetLowData[i].indexOf(value) % 3 == 1)
          .map<String>((value) {
        if (value is String) {
          return value;
        } else if (value is TextCellValue) {
          return value.value;
        } else if (value is IntCellValue) {
          return value.value.toString();
        } else {
          return value.toString();
        }
      }).toList();
      List<String> itemsB = sheetLowData[i]
          .skip(1)
          .where((value) => sheetLowData[i].indexOf(value) % 3 == 2)
          .map<String>((value) {
        if (value is String) {
          return value;
        } else if (value is TextCellValue) {
          return value.value;
        } else if (value is IntCellValue) {
          return value.value.toString();
        } else {
          return value.toString();
        }
      }).toList();
      List<String> itemsC = sheetLowData[i]
          .skip(1)
          .where((value) => sheetLowData[i].indexOf(value) % 3 == 0)
          .map<String>((value) {
        if (value is String) {
          return value;
        } else if (value is TextCellValue) {
          return value.value;
        } else if (value is IntCellValue) {
          return value.value.toString();
        } else {
          return value.toString();
        }
      }).toList();
      item = [itemsA, itemsB, itemsC];

      titles.add(sheetLowData[i][0].toString());
      items.add(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내부심사 체크리스트'),
          bottom: TabBar(
            tabs: [
              for (var title in titles)
                Tab(
                  text: title,
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var item in items)
              CheckListWidget(
                items: item,
              ),
          ],
        ),
      ),
    );
  }
}

class CheckListWidget extends ConsumerWidget {
  const CheckListWidget({
    super.key,
    required this.items,
  });

  final List<List<String>> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiles = ref.watch(tileViewModelProvider);
    final viewModel = ref.read(tileViewModelProvider.notifier);

    final List<String> frontItems = items[0];
    final List<String> backItems = items[1];

    // 아이템 수를 확인하여 tiles 길이와 일치하도록 함
    final itemCount =
        frontItems.length < tiles.length ? frontItems.length : tiles.length;

    return Column(
      children: [
        const Gap(30),
        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final tile = tiles[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    if (!tile.isNA) {
                      viewModel.toggleSelected(index);
                      viewModel.incrementCounter(index);
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    viewModel.markAsNA(index);
                  },
                  child: Stack(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        tileColor: tile.counter > 0
                            ? const Color(0x0f23656A)
                                .withOpacity(tile.counter * 0.2)
                            : Colors.white,
                        title: Text(
                          frontItems[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          backItems[index],
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        trailing: Text((tile.counter / 2).toString()),
                      ),
                      if (tile.isNA)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: Text(
                                "N/A 처리",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
