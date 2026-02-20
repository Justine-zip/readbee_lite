class Student {
  final String name;
  final String lrn;
  final String sex;
  final int age;
  final String? phone;
  final String? email;
  final String studentId;
  final String sectionId;
  final String? schoolId;

  Student({
    required this.name,
    required this.lrn,
    required this.sex,
    required this.age,
    this.phone,
    this.email,
    required this.sectionId,
    required this.studentId,
    this.schoolId,
  });

  factory Student.fromMap(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      lrn: json['lrn'],
      sex: json['sex'],
      age: json['age'],
      sectionId: json['sectionId'],
      studentId: json['studentId'],
    );
  }
}
