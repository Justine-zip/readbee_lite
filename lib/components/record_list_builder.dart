import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_circular_progress_indicator.dart';
import 'package:readbee_lite/notifiers/record_notifier.dart';
import 'package:readbee_lite/providers/record_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';

class RecordListBuilder extends ConsumerWidget {
  final int itemCount;
  final List<String> title;
  final Function(dynamic index)? onTap;
  const RecordListBuilder({
    super.key,
    required this.itemCount,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(sectionProvider);
    final recordState = ref.watch(recordProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final value =
              recordState.currentStep == RecordStep.section
                  ? sections[index].section
                  : title[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: InkWell(
                onTap: () {
                  onTap?.call(value);
                },
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const CustomCircularProgressIndicator(value: .6),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        padding: EdgeInsets.only(bottom: 100),
      ),
    );
  }
}
