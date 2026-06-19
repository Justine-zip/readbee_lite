import 'package:flutter/material.dart';

class ComprehensionScoreBox extends StatelessWidget {
  final String value;
  final String? subtitle;
  final double? size;
  final double? valueSize;
  final double? subTextSize;
  const ComprehensionScoreBox({
    super.key,
    required this.value,
    this.subtitle,
    this.size,
    this.valueSize,
    this.subTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 240,
      width: size ?? 240,
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
                        fontSize:
                            value.length > 3
                                ? (valueSize == null ? 22 : valueSize! / 1.5)
                                : (valueSize ?? 42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: subTextSize ?? 18),
                      ),
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
