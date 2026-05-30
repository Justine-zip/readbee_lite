import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_dropdown.dart';
import 'package:readbee_lite/models/material_filter.dart';
import 'package:readbee_lite/providers/material_filter_provider.dart';

class FilterSheet extends ConsumerWidget {
  final double sheetSize;
  final double textSize;
  const FilterSheet({
    super.key,
    required this.textSize,
    required this.sheetSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(materialFilterProvider);
    return DraggableScrollableSheet(
      initialChildSize: sheetSize,
      maxChildSize: sheetSize * 1.1,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Filter & Layout Settings',
                  style: TextStyle(
                    fontSize: 18 * textSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grade Level',
                            style: TextStyle(fontSize: 16 * textSize),
                          ),
                          CustomDropdown(
                            option: ['3', '4', '5', '6'],
                            value: filter.gradeLevel,
                            onChanged: (value) {
                              ref
                                  .read(materialFilterProvider.notifier)
                                  .state = filter.copyWith(gradeLevel: value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Language',
                            style: TextStyle(fontSize: 16 * textSize),
                          ),
                          CustomDropdown(
                            option: ['Filipino', 'English'],
                            value: filter.language,
                            onChanged: (value) {
                              ref
                                  .read(materialFilterProvider.notifier)
                                  .state = filter.copyWith(language: value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ref.read(materialFilterProvider.notifier).state =
                                MaterialFilter.empty;
                          },
                          child: Text(
                            'Reset Filter',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18 * textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
