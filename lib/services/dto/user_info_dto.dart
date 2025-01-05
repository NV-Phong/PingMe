class UserInfoDTO {
  final String displayName;
  final String email;
  final String username;
  final String? avatar;
  final String? cover;
  final String id;

  UserInfoDTO({
    required this.displayName,
    required this.email,
    this.avatar,
    this.cover,
    required this.username,
    required this.id,
  });

  factory UserInfoDTO.fromJson(Map<String, dynamic> json) {
    return UserInfoDTO(
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      cover: json['cover'] as String?,
      id: json['_id'] as String,
    );
  }
}
