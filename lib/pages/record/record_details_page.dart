import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/comprehension_score_box.dart';
import 'package:readbee_lite/components/custom_story_container.dart';
import 'package:readbee_lite/providers/assessment_record_provider.dart';
import 'package:readbee_lite/providers/quiz_question_provider.dart';
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
    final questionAsync = ref.watch(quizQuestionProvider);
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
                  '${record.selectedGrade} • ${record.selectedSection} • ${record.selectedLanguage} • ${record.selectedStudent!.name}',
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
                          const Text('Story', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 30),
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
                  const VerticalDivider(thickness: 8),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Story Evaluation',
                            style: TextStyle(fontSize: 40),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(24),
                              children: [
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
                                                  selectedMaterial?.materialId;
                                        }).toList();

                                    if (filteredAssessment.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'No record for selected student & language',
                                        ),
                                      );
                                    }

                                    final item = filteredAssessment.first;
                                    final readingScore = item.readingScore;
                                    final comprehensionScore =
                                        item.comprehensionScore;

                                    final Map<String, Color> miscueColors = {
                                      'Omission': Colors.purple,
                                      'Repetition': Colors.grey,
                                      'Substitution': Colors.red,
                                      'Reversal': Colors.blue,
                                      'Transposition': Colors.pink,
                                      'Insertion': Colors.yellow,
                                      'Mispronunciation': Colors.orange,
                                      'Correct': Colors.green,
                                    };

                                    final Map<int, Color> wordColors = {};

                                    final miscueContent =
                                        Map<String, dynamic>.from(
                                          item.miscueContent ?? {},
                                        );

                                    miscueContent.forEach((type, indexes) {
                                      final color =
                                          miscueColors[type] ?? Colors.black;

                                      for (final index in List<int>.from(
                                        indexes,
                                      )) {
                                        wordColors[index] = color;
                                      }
                                    });

                                    debugPrint(
                                      'misContent: ${item.miscueContent}',
                                    );

                                    final miscues =
                                        (readingScore['miscueSummary'] is List)
                                            ? List<Map<String, dynamic>>.from(
                                              readingScore['miscueSummary'],
                                            )
                                            : <Map<String, dynamic>>[];

                                    final miscueOverallSummary =
                                        (readingScore['miscueOverallSummary']
                                                is List)
                                            ? List<Map<String, dynamic>>.from(
                                              readingScore['miscueOverallSummary'],
                                            )
                                            : <Map<String, dynamic>>[];

                                    final comprehensionSummary =
                                        (comprehensionScore['comprehensionSummary']
                                                is List)
                                            ? List<Map<String, dynamic>>.from(
                                              comprehensionScore['comprehensionSummary'],
                                            )
                                            : <Map<String, dynamic>>[];

                                    final answerSummary =
                                        Map<String, dynamic>.from(
                                          comprehensionScore['answerSummary'] ??
                                              {},
                                        );

                                    return Column(
                                      children: [
                                        storyAsync.when(
                                          data: (story) {
                                            if (story == null) {
                                              return const Center(
                                                child: Text('No story found'),
                                              );
                                            }

                                            if (story.language !=
                                                record.selectedLanguage) {
                                              return const Center(
                                                child: Text(
                                                  'Language does not match',
                                                ),
                                              );
                                            }

                                            final titleWords = story.title
                                                .split(RegExp(r'\s+'));

                                            final contentWords = story.content
                                                .replaceAll('\n', ' ')
                                                .split(RegExp(r'\s+'));

                                            final titleWordCount =
                                                titleWords.length;
                                            return Material(
                                              elevation: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  24.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    RichText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        children: List.generate(
                                                          titleWords.length,
                                                          (index) => TextSpan(
                                                            text:
                                                                '${titleWords[index]} ',
                                                            style: TextStyle(
                                                              color:
                                                                  wordColors[index] ??
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    RichText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                          fontSize: 28,
                                                          color: Colors.black,
                                                        ),
                                                        children: List.generate(
                                                          contentWords.length,
                                                          (index) => TextSpan(
                                                            text:
                                                                '${contentWords[index]} ',
                                                            style: TextStyle(
                                                              color:
                                                                  wordColors[index +
                                                                      titleWordCount] ??
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          error:
                                              (e, _) => Center(
                                                child: Text(e.toString()),
                                              ),
                                          loading:
                                              () => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                        ),

                                        Column(
                                          children: [
                                            IntrinsicHeight(
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
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      m['count']
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      m['count']
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.normal,
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
                                            ),
                                            const SizedBox(height: 50),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ...comprehensionSummary.map((
                                                  c,
                                                ) {
                                                  return ComprehensionScoreBox(
                                                    subtitle: c['type'],
                                                    value:
                                                        c['count'].toString(),
                                                    size: 200,
                                                  );
                                                }),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 50),

                                        questionAsync.when(
                                          data: (question) {
                                            if (question.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  'No questions found',
                                                ),
                                              );
                                            }

                                            return Material(
                                              elevation: 3,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ...List.generate(question.length, (
                                                      index,
                                                    ) {
                                                      final studentAnswer =
                                                          answerSummary[index
                                                                  .toString()]
                                                              ?.toString() ??
                                                          '';

                                                      final studentAnswerIndex =
                                                          studentAnswer
                                                                  .isNotEmpty
                                                              ? studentAnswer
                                                                      .toUpperCase()
                                                                      .codeUnitAt(
                                                                        0,
                                                                      ) -
                                                                  65
                                                              : -1;

                                                      final correctAnswerIndex =
                                                          question[index]
                                                              .correctAnswer;

                                                      final isCorrect =
                                                          studentAnswerIndex ==
                                                          correctAnswerIndex;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 16,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${index + 1}. ${question[index].questionText}',
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                            ),

                                                            const SizedBox(
                                                              height: 8,
                                                            ),

                                                            ...List.generate(
                                                              question[index]
                                                                  .choices
                                                                  .length,
                                                              (choiceIndex) {
                                                                final choice =
                                                                    question[index]
                                                                        .choices[choiceIndex];

                                                                Color?
                                                                textColor;
                                                                FontWeight
                                                                fontWeight =
                                                                    FontWeight
                                                                        .normal;

                                                                if (choiceIndex ==
                                                                    correctAnswerIndex) {
                                                                  textColor =
                                                                      Colors
                                                                          .green;
                                                                  fontWeight =
                                                                      FontWeight
                                                                          .bold;
                                                                }

                                                                if (!isCorrect &&
                                                                    choiceIndex ==
                                                                        studentAnswerIndex) {
                                                                  textColor =
                                                                      Colors
                                                                          .red;
                                                                  fontWeight =
                                                                      FontWeight
                                                                          .bold;
                                                                }

                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            2,
                                                                      ),
                                                                  child: Text(
                                                                    '${choice.letter}. ${choice.choice}',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color:
                                                                          textColor,
                                                                      fontWeight:
                                                                          fontWeight,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            const SizedBox(
                                                              height: 8,
                                                            ),

                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'Student Answer: ',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),

                                                                Text(
                                                                  studentAnswer,
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        isCorrect
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            const Divider(
                                                              height: 32,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },

                                          loading:
                                              () => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),

                                          error:
                                              (e, _) => Center(
                                                child: Text(e.toString()),
                                              ),
                                        ),
                                      ],
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
