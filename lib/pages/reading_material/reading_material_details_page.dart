import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/pages/reading_material/digital_reading_page.dart';
import 'package:readbee_lite/providers/assessment_record_provider.dart';
import 'package:readbee_lite/providers/calendar_event_provider.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/pupil_provider.dart';
import 'package:readbee_lite/providers/quiz_question_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';

class ReadingMaterialDetailsPage extends ConsumerStatefulWidget {
  const ReadingMaterialDetailsPage({super.key});

  @override
  ConsumerState<ReadingMaterialDetailsPage> createState() =>
      _ReadingMaterialDetailsPageState();
}

class _ReadingMaterialDetailsPageState
    extends ConsumerState<ReadingMaterialDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(storyProvider);
    final quizQuestionAsync = ref.watch(quizQuestionProvider);

    return storyAsync.when(
      data: (story) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const PageTitle(title: 'Reading Material'),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TitleBar(
                    title: story!.title,
                    description: 'Bilang ng mga salita: ${story.wordCount}',
                    secondDescription: 'Language: ${story.language}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Material(
                          elevation: 3,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .675,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      story.title,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      story.content,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      quizQuestionAsync.when(
                        data: (questions) {
                          return Expanded(
                            flex: 2,
                            child: Material(
                              elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .675,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: questions.length,
                                          itemBuilder: (context, index) {
                                            final question = questions[index];

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  question.questionText,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                  ),
                                                ),

                                                const SizedBox(height: 12),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      for (var choice
                                                          in question.choices
                                                              .asMap()
                                                              .entries)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 8,
                                                              ),
                                                          child: Text(
                                                            "${choice.value.letter}. ${choice.value.choice}",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 24),
                                              ],
                                            );
                                          },
                                        ),
                                      ),

                                      CustomButton(
                                        onTap: () async {
                                          debugPrint('Tapped');

                                          final appointmentsAsync = ref.read(
                                            appointmentsProvider,
                                          );

                                          final appointments =
                                              appointmentsAsync.value;

                                          if (appointments == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Loading appointments...',
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          final now = DateTime.now();

                                          final hasTodayAppointment =
                                              appointments.any((a) {
                                                return a.startTime.year ==
                                                        now.year &&
                                                    a.startTime.month ==
                                                        now.month &&
                                                    a.startTime.day == now.day;
                                              });

                                          if (!hasTodayAppointment) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'No appointment for today',
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          evaluationList(context);
                                        },
                                        title: 'Proceed',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        loading:
                            () => Center(
                              child: Container(
                                color: Colors.transparent,
                                child: const Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/splashscreen/LoadingBee.gif',
                                    ),
                                    width: 200,
                                    height: 200,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              ),
                            ),
                        error: (e, _) => Text(e.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text(e.toString()),
    );
  }

  Future<dynamic> evaluationList(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const EvaluationListDialog(),
    );
  }
}

class EvaluationListDialog extends ConsumerWidget {
  const EvaluationListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evaluationProvider);
    final notifier = ref.read(evaluationProvider.notifier);

    final assessmentAsynnc = ref.watch(assessmentRecordProvider);
    final pupilAsync = ref.watch(pupilProvider);
    final sectionAsync = ref.watch(sectionProvider);

    return assessmentAsynnc.when(
      data: (assessmennt) {
        return pupilAsync.when(
          data: (pupil) {
            if (pupil == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return sectionAsync.when(
              data: (sectionData) {
                final List<Section> sections =
                    sectionData.map((s) {
                      return Section(
                        sectionId: s.sectionId,
                        schoolId: s.schoolId,
                        yearId: s.yearId,
                        gradeLevelId: s.gradeLevelId,
                        sectionName: s.sectionName,
                        status: s.status,
                        adviserName: s.adviserName,
                      );
                    }).toList();

                final List<Student> students =
                    pupil.map((p) {
                      return Student(
                        name: p.fullName,
                        lrn: p.lrn,
                        sectionId: p.sectionId,
                        studentId: p.pupilId,
                      );
                    }).toList();

                final sectionFilteredStudents = notifier.filteredStudents(
                  students,
                );

                final existingStudentIds =
                    (assessmennt ?? [])
                        .where(
                          (a) =>
                              a.materialId ==
                              ref.read(selectedMaterialProvider)!.materialId,
                        )
                        .map((a) => a.pupilId)
                        .toSet();

                final filteredStudents =
                    sectionFilteredStudents.where((student) {
                      return !existingStudentIds.contains(student.studentId);
                    }).toList();

                return Dialog(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width * .4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Section List",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: sections.length,
                                          itemBuilder: (context, index) {
                                            final section = sections[index];

                                            return ListTile(
                                              selected:
                                                  state.selectedSectionId ==
                                                  section.sectionId,
                                              selectedTileColor: Colors.amber
                                                  .withValues(alpha: .3),
                                              title: Text(
                                                section.sectionName ?? '',
                                              ),
                                              onTap: () {
                                                notifier.selectSection(
                                                  section.sectionId,
                                                  section.sectionName ?? '',
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const VerticalDivider(thickness: 4),

                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Student List",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 10),

                                      Expanded(
                                        child:
                                            filteredStudents.isEmpty
                                                ? const Center(
                                                  child: Text(
                                                    'No students available',
                                                  ),
                                                )
                                                : ListView.builder(
                                                  itemCount:
                                                      filteredStudents.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final studentItem =
                                                        filteredStudents[index];

                                                    return ListTile(
                                                      selected:
                                                          state
                                                              .selectedStudent
                                                              ?.studentId ==
                                                          studentItem.studentId,
                                                      selectedTileColor: Colors
                                                          .amber
                                                          .withValues(
                                                            alpha: .3,
                                                          ),
                                                      title: Text(
                                                        studentItem.name,
                                                      ),
                                                      onTap: () {
                                                        notifier.selectStudent(
                                                          studentItem,
                                                        );

                                                        debugPrint(
                                                          'Student: ${studentItem.studentId}',
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: CustomButton(
                                onTap:
                                    state.selectedStudent == null
                                        ? null
                                        : () {
                                          notifier.evaluate();

                                          Navigator.pop(context);

                                          Navigator.push(
                                            context,
                                            PageAnimationTransition(
                                              page: const DigitalReadingPage(),
                                              pageAnimationType:
                                                  RightToLeftTransition(),
                                            ),
                                          );
                                        },
                                title: 'Evaluate',
                                size: 150,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}
