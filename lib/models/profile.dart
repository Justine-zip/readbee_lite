class Profile {
  final String id;
  final String fullName;
  final String sex;
  final String phone;
  final String address;
  final String title;
  final String position;
  final String email;

  Profile({
    required this.id,
    required this.fullName,
    required this.sex,
    required this.phone,
    required this.address,
    required this.title,
    required this.position,
    required this.email,
  });

  factory Profile.fromMap(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      sex: json['sex'],
      phone: json['phone'],
      address: json['address'],
      title: json['title'],
      position: json['position'],
      email: json['email'],
    );
  }
}
