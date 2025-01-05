class ListChatDTO {
  final String chatName;
  final String? avatar;
  final String id;

  ListChatDTO({
    required this.chatName,
    this.avatar,
    required this.id,
  });

  factory ListChatDTO.fromJson(Map<String, dynamic> json) {
    return ListChatDTO(
      chatName: json['ChatName'] as String,
      avatar: json['Avatar'] as String?,
      id: json['_id'] as String,
    );
  }
}
