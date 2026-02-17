import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrientationManager extends StatefulWidget {
  final Widget child;

  const OrientationManager({super.key, required this.child});

  @override
  State<OrientationManager> createState() => _OrientationManagerState();
}

class _OrientationManagerState extends State<OrientationManager> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final width = MediaQuery.of(context).size.width;

    if (width >= 600) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
