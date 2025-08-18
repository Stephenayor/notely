class UserProfile {
  final String id;
  final String email;
  final String name;
  final String password;
  final DateTime joinDate;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'joinDate': joinDate,
    };
  }
}
