import 'package:check_list_qality/feature/const/questions/questions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final title = titleItems;
  final List<List<List<String>>> items = itemsAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: title.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내부심사 체크리스트'),
          bottom: TabBar(
            tabs: [
              for (var title in title) Tab(text: title),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var item in items) CheckListWidget(items: item),
          ],
        ),
      ),
    );
  }
}

class CheckListWidget extends StatelessWidget {
  const CheckListWidget({
    super.key,
    required this.items,
  });

  final List<List<String>> items;

  @override
  Widget build(BuildContext context) {
    final List<String> frontItems = items[0];
    final List<String> backItems = items[1];
    final List<bool> isChecked = List<bool>.filled(items[0].length, false);

    void clickCheck() {}
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: frontItems.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, followingIndex) {
              return CheckboxListTile(
                value: isChecked[followingIndex],
                onChanged: (context) => clickCheck,
                title: Text(frontItems[followingIndex]),
                subtitle: Text(backItems[followingIndex]),
              );
            },
          ),
        ),
      ],
    );
  }
}
