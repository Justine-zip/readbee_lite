import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:readbee_lite/models/miscue.dart';

class MiscueNotifier extends Notifier<List<Miscue>> {
  @override
  List<Miscue> build() {
    return [
      Miscue(name: 'Omission', count: 0, color: Colors.purple),
      Miscue(name: 'Repetition', count: 0, color: Colors.grey),
      Miscue(name: 'Substitution', count: 0, color: Colors.red),
      Miscue(name: 'Reversal', count: 0, color: Colors.blue),
      Miscue(name: 'Transposition', count: 0, color: Colors.pink),
      Miscue(name: 'Insertion', count: 0, color: Colors.yellow),
      Miscue(name: 'Mispronunciation', count: 0, color: Colors.orange),
      Miscue(name: 'Correct', count: 0, color: Colors.green),
    ];
  }

  void increment(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(count: state[i].count + 1)
        else
          state[i],
    ];
  }

  void reset() {
    state = [for (final miscue in state) miscue.copyWith(count: 0)];
  }
}
