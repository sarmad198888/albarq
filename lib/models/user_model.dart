class UserModel {
  final String id;
  final String name;
  final String username;
  final String password;
  final String role;
  final bool active;
  final bool approved;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    required this.active,
    required this.approved,
  });

  factory UserModel.fromMap(
  String id,
  Map<String, dynamic> data,
) {
  return UserModel(
    id: id,
    name: data['name'] ?? '',
    username: data['username'] ?? '',
    password: data['password'] ?? '',
    role: data['role'] ?? '',
    active: data['active'] ?? false,
    approved: data['approved'] ?? true,
  );
}
}