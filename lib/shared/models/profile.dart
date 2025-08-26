import '../../app/router.dart';

class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    required this.address,
    required this.role,
  });

  final String name;
  final String email;
  final String address;
  final AppRole role; // student or teacher

  Map<String, Object?> toJson() => {
        'name': name,
        'email': email,
        'address': address,
        'role': role.name,
      };

  static UserProfile fromJson(Map<String, Object?> json) => UserProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        role: (json['role'] as String) == 'teacher' ? AppRole.teacher : AppRole.student,
      );
}


