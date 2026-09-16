enum MemberRole {
  owner('Organizador'),
  editor('Editor'),
  viewer('Lector');

  final String label;
  const MemberRole(this.label);
}

class TripMember {
  final String id;
  final String tripId;
  final String userId;
  final MemberRole role;
  final String fullName;
  final String? avatarUrl;
  final DateTime joinedAt;

  const TripMember({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.role,
    required this.fullName,
    this.avatarUrl,
    required this.joinedAt,
  });

  factory TripMember.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return TripMember(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String,
      role: MemberRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => MemberRole.editor,
      ),
      fullName: profile?['full_name'] as String? ?? 'Participante',
      avatarUrl: profile?['avatar_url'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}
