import 'package:check_list_qality/models/tile_model.dart';
import 'package:check_list_qality/repositories/tile_repository.dart';
import 'package:check_list_qality/view_models/tile_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

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
                child: Column(
                  children: [
                    Stack(
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
                          title: Text(
                            tile.frontText,
                            style: GoogleFonts.notoSans(
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
                          trailing: Text("${tile.counter}"),
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
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {
                            if (!tile.isNA) {
                              viewModel.clickCounter(check, index, 0.0);
                            }
                          },
                          color: (tile.counter == 0.0) && (!tile.isNA)
                              ? Colors.blue
                              : Colors.grey.shade300,
                          child: const Text("0.0"),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {
                            if (!tile.isNA) {
                              viewModel.clickCounter(
                                  check, index, 0.5 * tile.points);
                            }
                          },
                          color: tile.counter == (0.5 * tile.points)
                              ? Colors.blue
                              : Colors.grey.shade300,
                          child: Text("${0.5 * tile.points}"),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {
                            if (!tile.isNA) {
                              viewModel.clickCounter(
                                  check, index, 1.0 * tile.points);
                            }
                          },
                          color: tile.counter == (1.0 * tile.points)
                              ? Colors.blue
                              : Colors.grey.shade300,
                          child: Text("${1 * tile.points}.0"),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          onPressed: () {
                            viewModel.markAsNA(check, index);
                          },
                          color: tile.isNA ? Colors.blue : Colors.grey.shade300,
                          child: const Text("N/A"),
                        ),
                      ],
                    )
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
