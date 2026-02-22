import 'package:flutter/material.dart';

class Miscue {
  final String name;
  final int count;
  final Color color;

  Miscue({required this.name, required this.count, required this.color});

  Miscue copyWith({String? name, int? count, Color? color}) {
    return Miscue(
      name: name ?? this.name,
      count: count ?? this.count,
      color: color ?? this.color,
    );
  }
}
