import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/pages/record/record_details_page.dart';
import 'package:readbee_lite/providers/record_provider.dart';

class StudentListDialog extends ConsumerWidget {
  StudentListDialog({super.key});

  final List<Student> student = [
    Student(
      name: 'Denmark Cabanhao',
      lrn: '0121',
      sectionId: '1',
      studentId: '1',
    ),
    Student(name: 'Romeo Ezguera', lrn: '0740', sectionId: '1', studentId: '2'),
    Student(name: 'Kori Sanchez', lrn: '0321', sectionId: '1', studentId: '3'),
    Student(name: 'Bill Fraud', lrn: '0353', sectionId: '2', studentId: '4'),
    Student(
      name: 'Juan Dela Cruz',
      lrn: '0586',
      sectionId: '2',
      studentId: '5',
    ),
    Student(name: 'Ezra Ramirez', lrn: '0835', sectionId: '3', studentId: '6'),
    Student(name: 'Tanya Suami', lrn: '0035', sectionId: '3', studentId: '7'),
    Student(
      name: 'Ralph Angsioco',
      lrn: '0655',
      sectionId: '3',
      studentId: '8',
    ),
    Student(name: 'Paolo Bentir', lrn: '0397', sectionId: '3', studentId: '9'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordState = ref.watch(recordProvider);

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
              Expanded(
                child: Column(
                  children: [
                    const Text("Student List", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: student.length,
                        itemBuilder: (context, index) {
                          final studentItem = student[index];
                          final selectedStudent = recordState.selectedStudent;

                          return ListTile(
                            selected:
                                selectedStudent?.studentId ==
                                studentItem.studentId,
                            selectedTileColor: Colors.amber.withOpacity(.3),
                            title: Text(
                              studentItem.name,
                              style: TextStyle(fontSize: 24),
                            ),
                            onTap: () {
                              ref
                                  .read(recordProvider.notifier)
                                  .selectedStudent(studentItem);
                            },
                          );
                        },
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
                        (ref.watch(recordProvider).selectedStudent != null)
                            ? () {
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const RecordDetailsPage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            }
                            : null,

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
