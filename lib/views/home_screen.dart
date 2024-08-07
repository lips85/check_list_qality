import 'package:check_list_qality/view_models/tile_view_model.dart';
import 'package:check_list_qality/views/checklist_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadTiles();
  }

  Future<void> _loadTiles() async {
    await ref.read(tileViewModelProvider.notifier).fetchTiles();
  }

  @override
  Widget build(BuildContext context) {
    final groupedTiles = ref.watch(tileViewModelProvider);
    final checkLists = groupedTiles.keys.toList();

    if (checkLists.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('내부심사 체크리스트'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: checkLists.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('내부심사 체크리스트'),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.zero,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            dividerColor: Colors.transparent,
            labelColor: Colors.white, // 선택된 탭의 글자색
            unselectedLabelColor: Colors.black, // 선택되지 않은 탭의 글자색
            indicator: BoxDecoration(
              color: const Color(0x0f23656A).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: [
              for (var check in checkLists)
                Tab(
                  height: 30,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      check == "시스템"
                          ? check.substring(0, 3)
                          : check.substring(0, 2),
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var check in checkLists)
              CheckListWidget(
                check: check,
                items: groupedTiles[check]!,
              ),
          ],
        ),
      ),
    );
  }
}
