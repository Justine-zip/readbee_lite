import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class DigitalReadingPage extends ConsumerStatefulWidget {
  const DigitalReadingPage({super.key});

  @override
  ConsumerState<DigitalReadingPage> createState() => _DigitalReadingPageState();
}

class _DigitalReadingPageState extends ConsumerState<DigitalReadingPage> {
  @override
  Widget build(BuildContext context) {
    final material = ref.watch(readingMaterialProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .675,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      material[0].title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      material[0].content,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
