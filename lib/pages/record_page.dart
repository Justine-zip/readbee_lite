import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/record_list_builder.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60),
            Text(
              'Select Grade Level',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            RecordListBuilder(
              title: 'Grade',
              onTap:
                  (level) => Navigator.of(context).push(
                    PageAnimationTransition(
                      page: SectionRecordPage(grade: level),
                      pageAnimationType: RightToLeftTransition(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionRecordPage extends StatelessWidget {
  final int grade;
  const SectionRecordPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60),
            Text(
              'Select Section (Grade $grade)',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            RecordListBuilder(
              title: 'Section',
              onTap:
                  (section) => Navigator.of(context).push(
                    PageAnimationTransition(
                      page: LanguageRecordPage(grade: grade, section: section),
                      pageAnimationType: RightToLeftTransition(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageRecordPage extends StatelessWidget {
  final int grade;
  final int section;
  const LanguageRecordPage({
    super.key,
    required this.grade,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60),
            Text(
              'Select Language (G$grade • S$section)',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            RecordListBuilder(
              title: 'Language',
              onTap: (language) {
                debugPrint(
                  'Grade $grade | Section $section | Language $language',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
