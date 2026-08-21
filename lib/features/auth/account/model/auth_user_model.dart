class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
  });
  final String id;
  final String name;
  final String email;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
    id: '${json['id'] ?? ''}',
    name: '${json['name'] ?? json['fullName'] ?? ''}',
    email: '${json['email'] ?? ''}',
  );
}

class AuthSessionModel {
  const AuthSessionModel({required this.user, required this.token});
  final AuthUserModel user;
  final String token;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final userJson = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'])
        : data;
    final token =
        '${data['token'] ?? data['accessToken'] ?? data['tokens']?['accessToken'] ?? ''}';
    return AuthSessionModel(
      user: AuthUserModel.fromJson(userJson),
      token: token,
    );
  }
}
