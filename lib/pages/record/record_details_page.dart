import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_story_container.dart';
import 'package:readbee_lite/providers/assessment_record_provider.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';
import 'package:readbee_lite/providers/record_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';

class RecordDetailsPage extends ConsumerStatefulWidget {
  const RecordDetailsPage({super.key});

  @override
  ConsumerState<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends ConsumerState<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final record = ref.watch(recordProvider);
    final materialAsync = ref.watch(readingMaterialProvider);
    final storyAsync = ref.watch(storyProvider);
    final assessmentAsync = ref.watch(assessmentRecordProvider);
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                          Expanded(
                            child: materialAsync.when(
                              data: (material) {
                                final filtered =
                                    material
                                        .where(
                                          (m) =>
                                              m.language ==
                                              record.selectedLanguage,
                                        )
                                        .toList();

                                return ListView.builder(
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        debugPrint(
                                          'xData: ${filtered[index].title}',
                                        );
                                        ref
                                            .read(
                                              selectedMaterialProvider.notifier,
                                            )
                                            .state = filtered[index];
                                      },
                                      child: CustomStoryContainer(
                                        title: filtered[index].title,
                                      ),
                                    );
                                  },
                                );
                              },

                              loading:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),

                              error:
                                  (e, _) => Center(child: Text(e.toString())),
                            ),
                          ),
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
                          Expanded(
                            child: storyAsync.when(
                              data: (story) {
                                if (story == null) {
                                  return const Center(
                                    child: Text('No story found'),
                                  );
                                }

                                if (story.language != record.selectedLanguage) {
                                  return const Center(
                                    child: Text('Language does not match'),
                                  );
                                }

                                return ListView(
                                  padding: const EdgeInsets.all(24),
                                  children: [
                                    Material(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              story.title,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              story.content.replaceAll(
                                                '\n',
                                                ' ',
                                              ),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    assessmentAsync.when(
                                      data: (assessment) {
                                        if (assessment == null ||
                                            assessment.isEmpty) {
                                          return const Center(
                                            child: Text('No reading score'),
                                          );
                                        }

                                        final selectedStudentId =
                                            record.selectedStudent?.studentId;
                                        final selectedMaterial = ref.read(
                                          selectedMaterialProvider,
                                        );

                                        final filteredAssessment =
                                            assessment.where((a) {
                                              return a.pupilId ==
                                                      selectedStudentId &&
                                                  a.materialId ==
                                                      selectedMaterial!
                                                          .materialId;
                                            }).toList();

                                        if (filteredAssessment.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No record for selected student & language',
                                            ),
                                          );
                                        }

                                        final item = filteredAssessment.first;
                                        final raw = item.readingScore;

                                        final miscues =
                                            (raw['miscueSummary'] is List)
                                                ? List<
                                                  Map<String, dynamic>
                                                >.from(raw['miscueSummary'])
                                                : <Map<String, dynamic>>[];

                                        final miscueOverallSummary =
                                            (raw['miscueOverallSummary']
                                                    is List)
                                                ? List<
                                                  Map<String, dynamic>
                                                >.from(
                                                  raw['miscueOverallSummary'],
                                                )
                                                : <Map<String, dynamic>>[];

                                        return IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Card(
                                                  color: Colors.white,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 12,
                                                      ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          24,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          miscues.map((m) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '${m['type']}:',
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  m['count']
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                flex: 4,
                                                child: Card(
                                                  color: Colors.white,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 12,
                                                      ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          24,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          miscueOverallSummary.map((
                                                            m,
                                                          ) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '${m['type']}:',
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  m['count']
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      loading:
                                          () => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      error:
                                          (e, _) =>
                                              Center(child: Text(e.toString())),
                                    ),
                                  ],
                                );
                              },

                              loading:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),

                              error:
                                  (e, _) => Center(child: Text(e.toString())),
                            ),
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
