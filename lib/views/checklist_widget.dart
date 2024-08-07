import 'package:check_list_qality/models/tile_model.dart';

import 'package:check_list_qality/view_models/tile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CheckListWidget extends ConsumerWidget {
  const CheckListWidget({
    super.key,
    required this.check,
    required this.items,
  });

  final String check;
  final List<TileModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(tileViewModelProvider.notifier);

    return Column(
      children: [
        const Gap(20),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final tile = items[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                              .withOpacity(tile.counter / tile.points * 0.5)
                          : Colors.white,
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tile.frontText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            tile.backText,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const Gap(10)
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PointButton(
                            tile: tile,
                            index: index,
                            num: 0.0,
                            viewModel: viewModel,
                            check: check,
                          ),
                          PointButton(
                            tile: tile,
                            index: index,
                            num: 0.5,
                            viewModel: viewModel,
                            check: check,
                          ),
                          PointButton(
                            tile: tile,
                            index: index,
                            num: 1.0,
                            viewModel: viewModel,
                            check: check,
                          ),
                          const Gap(30),
                          GestureDetector(
                            onTap: () {
                              viewModel.markAsNA(check, index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: tile.isNA
                                    ? const Color(0x0f23656A).withOpacity(0.5)
                                    : Colors.grey.shade300,
                              ),
                              child: Text(
                                "N/A",
                                style: TextStyle(
                                  color:
                                      tile.isNA ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (tile.isNA)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            viewModel.markAsNA(check, index);
                          },
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
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PointButton extends StatelessWidget {
  const PointButton({
    super.key,
    required this.tile,
    required this.viewModel,
    required this.check,
    required this.index,
    required this.num,
  });

  final TileModel tile;
  final TileViewModel viewModel;
  final String check;
  final int index;
  final double num;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!tile.isNA) {
          viewModel.clickCounter(check, index, num * tile.points);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: tile.counter == (num * tile.points) && (!tile.isNA)
              ? const Color(0x0f23656A).withOpacity(0.5)
              : Colors.grey.shade300,
        ),
        child: Text(
          "${num * tile.points}",
          style: TextStyle(
            color: tile.counter == (num * tile.points) && (!tile.isNA)
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
