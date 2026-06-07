import 'package:flutter/material.dart';

class MaterialTitleBar extends StatelessWidget {
  final String name;
  final String gradeSection;
  final String teacher;

  final double? nameSize;
  final double? gradeSectionSize;
  final double? teacherSize;

  final double? pad;
  const MaterialTitleBar({
    super.key,
    required this.name,
    required this.gradeSection,
    this.teacher = '',

    this.nameSize,
    this.gradeSectionSize,
    this.teacherSize,

    this.pad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(pad ?? 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: nameSize ?? 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              gradeSection,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: gradeSectionSize ?? 22,
              ),
            ),
            if (teacher != '') ...[
              const SizedBox(height: 2),
              Text(
                teacher,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: teacherSize ?? 22,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
