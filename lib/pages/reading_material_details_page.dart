import 'package:flutter/material.dart';
import 'package:readbee_lite/components/title_bar.dart';

class ReadingMaterialDetailsPage extends StatefulWidget {
  final String title;
  final String language;
  final int wordLength;
  const ReadingMaterialDetailsPage({
    super.key,
    required this.title,
    required this.language,
    required this.wordLength,
  });

  @override
  State<ReadingMaterialDetailsPage> createState() =>
      _ReadingMaterialDetailsPageState();
}

class _ReadingMaterialDetailsPageState
    extends State<ReadingMaterialDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TitleBar(
              title: widget.title,
              description: 'Bilang ng mga salita: ${widget.wordLength}',
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * .725,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            widget.title,
                            style: TextStyle(fontSize: 24),
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
                      child: Container(
                        height: MediaQuery.of(context).size.height * .725,
                        color: Colors.green,

                        child: Text('Material Quiz'),
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
