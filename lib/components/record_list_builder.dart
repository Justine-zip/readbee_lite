import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_circular_progress_indicator.dart';
import 'package:readbee_lite/providers/completion_rate_provider.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';
import 'package:showcaseview/showcaseview.dart';

class RecordListBuilder extends ConsumerStatefulWidget {
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
  ConsumerState<RecordListBuilder> createState() => _RecordListBuilderState();
}

class _RecordListBuilderState extends ConsumerState<RecordListBuilder> {
  final GlobalKey listKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final showcase = ShowCaseWidget.of(context);
      showcase.startShowCase([listKey]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sectionsAsync = ref.watch(sectionProvider);
    final gradeRateAsync = ref.watch(gradeRateProvider);
    final sectionRateAsync = ref.watch(sectionRateProvider);
    final gradeLevelsAsync = ref.watch(gradeLevelProvider);

    return sectionsAsync.when(
      data: (sections) {
        return Expanded(
          child: ListView.builder(
            itemCount: widget.itemCount,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              final value = widget.title[index];

              final gradeRates = gradeRateAsync.value ?? <String, double>{};
              final sectionRates = sectionRateAsync.value ?? <String, double>{};
              final gradeLevels = gradeLevelsAsync.value ?? [];

              double progressValue = 0;

              final isGrade = value.startsWith('Grade');
              final isSection = sections.any((s) => s.sectionName == value);

              if (isGrade) {
                final matchedGrade = gradeLevels.firstWhere(
                  (g) => 'Grade ${g.gradeNumber}' == value,
                  orElse: () => gradeLevels.first,
                );

                progressValue = gradeRates[matchedGrade.gradeLevelId] ?? 0;
              } else if (isSection) {
                final matchedSection = sections.firstWhere(
                  (s) => s.sectionName == value,
                  orElse: () => sections.first,
                );

                progressValue = sectionRates[matchedSection.sectionId] ?? 0;
              }

              final showIndicator = isGrade || isSection;

              Widget card = Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12,
                ),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: InkWell(
                    onTap: () => widget.onTap?.call(value),
                    child: Padding(
                      padding: const EdgeInsets.all(42.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (showIndicator)
                            CustomCircularProgressIndicator(
                              value: progressValue,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

              if (index == 0) {
                return Showcase(
                  key: listKey,
                  title: 'Pupil Record',
                  description: 'Tap to view $value record',
                  child: card,
                );
              }

              return card;
            },
          ),
        );
      },
      loading:
          () =>
              const Expanded(child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Expanded(child: Center(child: Text(e.toString()))),
    );
  }
}
