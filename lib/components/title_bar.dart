import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final String description;
  final String secondDescription;
  final double? titleSize;
  final double? descriptionSize;
  final double? secondDescriptionSize;
  const TitleBar({
    super.key,
    required this.title,
    required this.description,
    this.secondDescription = '',
    this.titleSize,
    this.descriptionSize,
    this.secondDescriptionSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black,
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
                color: Colors.white,
                fontSize: titleSize ?? 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: descriptionSize ?? 18,
              ),
            ),
            if (secondDescription != '') ...[
              const SizedBox(height: 2),
              Text(
                secondDescription,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: secondDescriptionSize ?? 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
