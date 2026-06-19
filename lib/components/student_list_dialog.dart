import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/viewmodels/providers/pupil_provider.dart';
import 'package:readbee_lite/viewmodels/providers/record_provider.dart';
import 'package:readbee_lite/views/record/record_details_page.dart';

class MobileStudentListDialog extends ConsumerWidget {
  const MobileStudentListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);
    final pupilsAsync = ref.watch(pupilProvider);

    final selectedStudent = ref.watch(recordProvider).selectedStudent;

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text("Pupil List", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),

              Expanded(
                child: pupilsAsync.when(
                  data: (pupils) {
                    if (pupils == null || pupils.isEmpty) {
                      return const Center(child: Text("No pupils found"));
                    }

                    final sectionId = recordState.selectedSectionId;

                    final filteredPupils =
                        pupils.where((p) => p.sectionId == sectionId).toList();

                    return ListView.builder(
                      itemCount: filteredPupils.length,
                      itemBuilder: (context, index) {
                        final pupilItem = filteredPupils[index];
                        final selectedStudent = recordState.selectedStudent;

                        return ListTile(
                          selected:
                              selectedStudent?.studentId == pupilItem.pupilId,
                          selectedTileColor: Colors.amber.withValues(alpha: .3),

                          title: Text(
                            pupilItem.fullName,
                            style: const TextStyle(fontSize: 16),
                          ),

                          subtitle: Text(
                            pupilItem.lrn,
                            style: const TextStyle(fontSize: 12),
                          ),

                          onTap: () {
                            ref
                                .read(recordProvider.notifier)
                                .selectedStudent(
                                  Student(
                                    studentId: pupilItem.pupilId,
                                    name: pupilItem.fullName,
                                    lrn: pupilItem.lrn,
                                    sectionId: pupilItem.sectionId,
                                  ),
                                );
                          },
                        );
                      },
                    );
                  },

                  loading:
                      () => const Center(child: CircularProgressIndicator()),

                  error: (err, stack) => Center(child: Text("Error: $err")),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomButton(
                    onTap:
                        selectedStudent == null
                            ? null
                            : () {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const MobileRecordDetailsPage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            },
                    title: 'Evaluate',
                    pad: 10,
                    size: 120,
                    tSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabletStudentListDialog extends ConsumerWidget {
  const TabletStudentListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);
    final pupilsAsync = ref.watch(pupilProvider);

    final selectedStudent = ref.watch(recordProvider).selectedStudent;

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text("Pupil List", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),

              Expanded(
                child: pupilsAsync.when(
                  data: (pupils) {
                    if (pupils == null || pupils.isEmpty) {
                      return const Center(child: Text("No pupils found"));
                    }

                    final sectionId = recordState.selectedSectionId;

                    final filteredPupils =
                        pupils.where((p) => p.sectionId == sectionId).toList();

                    return ListView.builder(
                      itemCount: filteredPupils.length,
                      itemBuilder: (context, index) {
                        final pupilItem = filteredPupils[index];
                        final selectedStudent = recordState.selectedStudent;

                        return ListTile(
                          selected:
                              selectedStudent?.studentId == pupilItem.pupilId,
                          selectedTileColor: Colors.amber.withValues(alpha: .3),

                          title: Text(
                            pupilItem.fullName,
                            style: const TextStyle(fontSize: 24),
                          ),

                          subtitle: Text(pupilItem.lrn),

                          onTap: () {
                            ref
                                .read(recordProvider.notifier)
                                .selectedStudent(
                                  Student(
                                    studentId: pupilItem.pupilId,
                                    name: pupilItem.fullName,
                                    lrn: pupilItem.lrn,
                                    sectionId: pupilItem.sectionId,
                                  ),
                                );
                          },
                        );
                      },
                    );
                  },

                  loading:
                      () => const Center(child: CircularProgressIndicator()),

                  error: (err, stack) => Center(child: Text("Error: $err")),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomButton(
                    onTap:
                        selectedStudent == null
                            ? null
                            : () {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const TabletRecordDetailsPage(),
                                  pageAnimationType: RightToLeftTransition(),
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
  }
}
