import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_story_container.dart';
import 'package:readbee_lite/providers/record_provider.dart';

class RecordDetailsPage extends ConsumerStatefulWidget {
  const RecordDetailsPage({super.key});

  @override
  ConsumerState<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends ConsumerState<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final record = ref.watch(recordProvider);
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
                  '${record.selectedGrade} • ${record.selectedSection} • ${record.selectedLanguage}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text('Story', style: TextStyle(fontSize: 40)),
                          SizedBox(height: 30),
                          CustomStoryContainer(title: 'Ang Loro ni Lolo Kiko'),
                          CustomStoryContainer(title: 'Ang Ibong Adarna'),
                          CustomStoryContainer(title: 'Ang Aso sa Lungga'),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(thickness: 8),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Story Evaluation',
                            style: TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
