import 'package:flutter/material.dart';

class ComprehensionScoreBox extends StatelessWidget {
  final String value;
  final String? subtitle;
  final double? size;
  const ComprehensionScoreBox({
    super.key,
    required this.value,
    this.subtitle,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 200,
      width: size ?? 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 220,
          child: Card(
            elevation: 3,
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: value.length > 3 ? 24 : 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 10),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
