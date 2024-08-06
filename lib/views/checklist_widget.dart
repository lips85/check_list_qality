import 'package:check_list_qality/models/tile_model.dart';
import 'package:check_list_qality/view_models/tile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CheckListWidget extends ConsumerWidget {
  const CheckListWidget({
    super.key,
    required this.system,
    required this.items,
  });

  final String system;
  final List<TileModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(tileViewModelProvider.notifier);

    return Column(
      children: [
        const Gap(30),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final tile = items[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    if (!tile.isNA) {
                      viewModel.toggleCounter(system, index);
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    viewModel.markAsNA(system, index);
                  },
                  child: Stack(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        tileColor: tile.counter > 0 && tile.counter <= 1
                            ? const Color(0x0f23656A)
                                .withOpacity(tile.counter * 0.5)
                            : Colors.white,
                        title: Text(
                          tile.frontText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          tile.backText,
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
