import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> option;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.option,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 150,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        alignment: Alignment.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        items:
            option.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
