import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_dropdown.dart';

class FilterSheet extends StatelessWidget {
  final double sheetSize;
  final double textSize;
  const FilterSheet({
    super.key,
    required this.textSize,
    required this.sheetSize,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: sheetSize,
      maxChildSize: sheetSize * 1.1,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Filter & Layout Settings',
                  style: TextStyle(
                    fontSize: 18 * textSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grade Level',
                            style: TextStyle(fontSize: 16 * textSize),
                          ),
                          CustomDropdown(option: ['1', '2', '3']),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Language',
                            style: TextStyle(fontSize: 16 * textSize),
                          ),
                          CustomDropdown(option: ['Tagalog', 'English']),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            'Reset Filter',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18 * textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grid Count',
                            style: TextStyle(fontSize: 16 * textSize),
                          ),
                          SizedBox(
                            width: 150,
                            child: Slider(
                              activeColor: Colors.amber,
                              divisions: 3,
                              value: .1,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
