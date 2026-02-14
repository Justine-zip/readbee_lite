import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> option;
  const CustomDropdown({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 150,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        alignment: Alignment.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        items:
            option.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
        onChanged: (String? newValue) {},
      ),
    );
  }
}
