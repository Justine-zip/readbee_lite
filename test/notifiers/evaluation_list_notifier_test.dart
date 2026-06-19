import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/notifiers/evaluation_list_notifier.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';

void main() {
  late ProviderContainer container;
  late EvaluationNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(evaluationProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is empty', () {
    expect(notifier.state.selectedSectionId, null);
    expect(notifier.state.selectedSection, null);
    expect(notifier.state.selectedStudent, null);
  });

  test('selectSection updates state and clears student', () {
    notifier.selectSection('1', 'Section A');

    expect(notifier.state.selectedSectionId, '1');
    expect(notifier.state.selectedSection, 'Section A');
    expect(notifier.state.selectedStudent, null);
  });

  test('selectStudent updates selectedStudent', () {
    final student = Student(
      name: 'name',
      lrn: 'lrn',
      sectionId: '1',
      studentId: '1',
    );

    notifier.selectStudent(student);

    expect(notifier.state.selectedStudent, student);
  });

  test('filteredStudents returns only students in selected section', () {
    notifier.selectSection('1', 'Section A');

    final students = [
      Student(name: 'John', lrn: 'lrn', sectionId: '1', studentId: '1'),
      Student(name: 'Mark', lrn: 'lrn', sectionId: '2', studentId: '2'),
      Student(name: 'Myra', lrn: 'lrn', sectionId: '1', studentId: '3'),
    ];

    final result = notifier.filteredStudents(students);

    expect(result.length, 2);
    expect(result.every((s) => s.sectionId == '1'), true);
  });

  test('filteredStudents returns empty list when no section selected', () {
    final students = [
      Student(name: 'John', lrn: 'lrn', sectionId: '1', studentId: '1'),
    ];

    expect(notifier.filteredStudents(students), isEmpty);
  });

  test('reset clears state', () {
    notifier.selectSection('1', 'Section A');

    notifier.reset();

    expect(notifier.state.selectedSectionId, null);
    expect(notifier.state.selectedSection, null);
    expect(notifier.state.selectedStudent, null);
  });
}
