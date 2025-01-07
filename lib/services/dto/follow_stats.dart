class FollowStatsDTO {
  final int? numberOfFollowers;
  final int? numberOfFollowing;

  FollowStatsDTO({
    this.numberOfFollowers,
    this.numberOfFollowing,
  });

  factory FollowStatsDTO.fromJson(Map<String, dynamic> json) {
    return FollowStatsDTO(
      numberOfFollowers: json['numberOfFollowers'] as int? ?? 0,
      numberOfFollowing: json['numberOfFollowing'] as int? ?? 0,
    );
  }
}
