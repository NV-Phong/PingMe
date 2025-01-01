class RegisterDTO {
  final String username, password, email, displayName;

  RegisterDTO({
    required this.username,
    required this.password,
    required this.email,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'displayName': displayName,
      };
}
