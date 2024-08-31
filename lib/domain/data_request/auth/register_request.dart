class RegisterRequest {
  final String email;
  final String name;
  final String password;
  RegisterRequest(
      {required this.email, required this.name, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'fullname': name,
        'role': 'USER',
      };
}
