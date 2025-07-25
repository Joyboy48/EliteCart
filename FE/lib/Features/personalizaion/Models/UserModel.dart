class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String gender;
  final String dob;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
    );
  }
}
