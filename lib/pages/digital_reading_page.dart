import 'package:flutter/material.dart';

class DigitalReadingPage extends StatefulWidget {
  const DigitalReadingPage({super.key});

  @override
  State<DigitalReadingPage> createState() => _DigitalReadingPageState();
}

class _DigitalReadingPageState extends State<DigitalReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'D I G I T A L  E V A L U A T I O N',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
