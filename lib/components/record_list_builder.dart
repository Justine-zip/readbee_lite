import 'package:flutter/material.dart';

class RecordListBuilder extends StatelessWidget {
  final Function(int index)? onTap;
  const RecordListBuilder({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: InkWell(
                onTap: () => onTap?.call(index),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Grade $index',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
