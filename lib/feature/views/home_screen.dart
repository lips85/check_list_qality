import 'package:check_list_qality/feature/const/questions/questions.dart';
import 'package:check_list_qality/feature/view_models/tile_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  final titles = titleItems;
  final List<List<List<String>>> items = itemsAll;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.titles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내부심사 체크리스트'),
          bottom: TabBar(
            tabs: [
              for (var title in widget.titles)
                Tab(
                  text: title,
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var item in widget.items)
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
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.grey),
                        ),
                        tileColor: tile.counter > 0
                            ? Colors.blue[100 * tile.counter]
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
                        trailing: Text(tile.counter.toString()),
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
