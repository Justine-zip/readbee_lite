import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/record_list_builder.dart';
import 'package:readbee_lite/components/student_list_dialog.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/viewmodels/notifiers/record_notifier.dart';
import 'package:readbee_lite/viewmodels/providers/record_provider.dart';

class MobileRecordPage extends ConsumerWidget {
  const MobileRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);
    final notifier = ref.read(recordProvider.notifier);

    final listValue = notifier.currentOptions;
    final title = notifier.currentTitle;
    final itemCount = listValue.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const TitleBar(
              title: 'Class Record',
              description: 'Record of pupils you evaluated',
              titleSize: 16,
              descriptionSize: 12,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
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
              key: ValueKey(recordState.selectedGradeLevelId),
              itemCount: itemCount,
              title: listValue,
              hPad: 0,
              vPad: 4,
              pad: 18,
              size: 50,
              tSize: 12,
              onTap: (value) {
                final shouldNavigate = notifier.handleSelection(
                  value.toString(),
                );

                if (shouldNavigate) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const MobileStudentListDialog();
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TabletRecordPage extends ConsumerWidget {
  const TabletRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);
    final notifier = ref.read(recordProvider.notifier);

    final listValue = notifier.currentOptions;
    final title = notifier.currentTitle;
    final itemCount = listValue.length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              key: ValueKey(recordState.selectedGradeLevelId),
              itemCount: itemCount,
              title: listValue,
              onTap: (value) {
                final shouldNavigate = notifier.handleSelection(
                  value.toString(),
                );

                if (shouldNavigate) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const TabletStudentListDialog();
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
