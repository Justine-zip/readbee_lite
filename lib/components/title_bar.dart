import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final String description;
  final String secondDescription;
  const TitleBar({
    super.key,
    required this.title,
    required this.description,
    this.secondDescription = '',
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 18,
              ),
            ),
            if (secondDescription != '') ...[
              SizedBox(height: 2),
              Text(
                secondDescription,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
