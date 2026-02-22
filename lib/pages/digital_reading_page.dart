import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_icon_button.dart';
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
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),

              //Timer
              Text(
                '00:00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),

              //Score Counter
              Text(
                '0',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),

              //Reading Material
              Center(
                child: Material(
                  elevation: 3,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              material[0].title,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              material[0].content,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Spacer(),

              // Miscue Digital Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 220.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Miscue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
          //Flag & Reset Buttons
          Positioned(
            top: 150,
            right: 125,
            child: CustomIconButton(
              icon: Icons.flag,
              radius: 30,
              color: Colors.grey,
              onTap: () {},
              iconSize: 18,
              iconColor: Colors.white,
            ),
          ),
          Positioned(
            top: 150,
            right: 50,
            child: CustomIconButton(
              icon: Icons.restart_alt_rounded,
              radius: 30,
              color: Colors.amber,
              onTap: () {},
              iconSize: 18,
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
