import 'package:flutter/material.dart';

class MaterialTitleBar extends StatelessWidget {
  final String name;
  final String gradeSection;
  final String teacher;
  const MaterialTitleBar({
    super.key,
    required this.name,
    required this.gradeSection,
    this.teacher = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 8),
            Text(
              gradeSection,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 22,
              ),
            ),
            if (teacher != '') ...[
              SizedBox(height: 2),
              Text(
                teacher,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 22,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
