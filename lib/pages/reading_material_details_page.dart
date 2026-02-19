import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/reading_material.dart';

class ReadingMaterialDetailsPage extends StatefulWidget {
  final List<ReadingMaterial> material;
  const ReadingMaterialDetailsPage({super.key, required this.material});

  @override
  State<ReadingMaterialDetailsPage> createState() =>
      _ReadingMaterialDetailsPageState();
}

class _ReadingMaterialDetailsPageState
    extends State<ReadingMaterialDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TitleBar(
              title: widget.material[0].title,
              description:
                  'Bilang ng mga salita: ${widget.material[0].wordLength}',
              secondDescription: 'Language: ${widget.material[0].language}',
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Material(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .675,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.material[0].title,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  widget.material[0].content,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Material(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .675,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: widget.material[0].question.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.material[0].question[index],
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var key
                                                  in widget
                                                      .material[0]
                                                      .key[index]
                                                      .asMap()
                                                      .entries)
                                                Text(
                                                  "${String.fromCharCode(65 + key.key)}. ${key.value}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  padding: const EdgeInsets.only(bottom: 50),
                                ),
                              ),

                              CustomButton(
                                onTap: () {
                                  debugPrint('Tapped');
                                },
                                title: 'Proceed',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
