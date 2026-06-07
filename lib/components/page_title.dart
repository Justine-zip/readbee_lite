import 'package:flutter/widgets.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double? size;
  final double? pad;
  const PageTitle({super.key, required this.title, this.size, this.pad});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: pad ?? 50.0),
        child: Text(
          title,
          style: TextStyle(fontSize: size ?? 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
