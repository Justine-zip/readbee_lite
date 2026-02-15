import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/record_list_builder.dart';
import 'package:readbee_lite/models/record_state.dart';
import 'package:readbee_lite/providers/record_provider.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);
    final notifier = ref.read(recordProvider.notifier);

    int itemCount;
    String title;
    String listTitle;

    switch (recordState.currentStep) {
      case RecordStep.grade:
        itemCount = 6;
        title = 'Grade Level';
        listTitle = 'Grade';
        break;

      case RecordStep.section:
        itemCount = 4;
        title = 'Section (Grade ${recordState.selectedGrade})';
        listTitle = 'Section';
        break;

      case RecordStep.language:
        itemCount = 2;
        title =
            'Language (G${recordState.selectedGrade} • S${recordState.selectedSection})';
        listTitle = 'Language';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            const Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child:
                      recordState.currentStep != RecordStep.grade
                          ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: notifier.goBack,
                          )
                          : null,
                ),
              ],
            ),

            RecordListBuilder(
              itemCount: itemCount,
              title: listTitle,
              onTap: (value) {
                if (recordState.currentStep == RecordStep.grade) {
                  notifier.selectGrade(value);
                } else if (recordState.currentStep == RecordStep.section) {
                  notifier.selectSection(value);
                } else {
                  debugPrint(
                    'Grade ${recordState.selectedGrade} | '
                    'Section ${recordState.selectedSection} | '
                    'Language $value',
                  );
                }
              },
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
