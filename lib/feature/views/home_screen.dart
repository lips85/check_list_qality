import 'package:check_list_qality/feature/const/questions/questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final title = titleItems;
  final items = followItems;

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

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, followingIndex) {
              return Text(
                items[followingIndex],
              );
            },
          ),
        ),
      ],
    );
  }
}
