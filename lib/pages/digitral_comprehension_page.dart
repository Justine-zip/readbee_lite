import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class DigitralComprehensionPage extends ConsumerStatefulWidget {
  const DigitralComprehensionPage({super.key});

  @override
  ConsumerState<DigitralComprehensionPage> createState() =>
      _DigitralComprehensionPageState();
}

class _DigitralComprehensionPageState
    extends ConsumerState<DigitralComprehensionPage> {
  @override
  Widget build(BuildContext context) {
    final question = ref.watch(readingMaterialProvider);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),

          //Progress Indicator
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width * .7,
            child: LinearProgressIndicator(value: .3),
          ),

          SizedBox(height: 30),

          //Questions
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height * .3,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      question[0].question[4],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 42),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),

          //Choices
          SizedBox(
            height: 220,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: question[0].key[0].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 220,
                      child: Card(
                        elevation: 3,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                question[0].key[0][index],
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
