import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_circular_progress_indicator.dart';

class RecordListBuilder extends StatelessWidget {
  final int itemCount;
  final String title;
  final Function(int index)? onTap;
  const RecordListBuilder({
    super.key,
    required this.itemCount,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              child: InkWell(
                onTap: () => onTap?.call(index),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$title $index',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomCircularProgressIndicator(value: .4),
                    ],
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
