import 'package:check_list_qality/view_models/tile_view_model.dart';
import 'package:check_list_qality/views/checklist_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          title: const Text('내부심사 체크리스트'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: checkLists.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내부심사 체크리스트'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (var check in checkLists)
                Tab(
                  text: check,
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
