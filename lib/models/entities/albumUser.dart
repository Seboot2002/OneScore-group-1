enum RankState { pending, valued }

class Albumuser {
  final int userId;
  final int albumId;
  final DateTime rankDate;
  final RankState rankState;

  Albumuser({
    required this.userId,
    required this.albumId,
    required this.rankDate,
    required this.rankState,
  });

  factory Albumuser.fromJson(Map<String, dynamic> json) {
    return Albumuser(
      userId: json['userId'],
      albumId: json['albumId'],
      rankDate: DateTime.parse(json['rankDate']),
      rankState: RankState.values.firstWhere(
        (e) => e.toString().split('.').last == json['rankState'],
        orElse: () => RankState.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'albumId': albumId,
      'rankDate': rankDate.toIso8601String(),
      'rankState': rankState.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return 'AlbumUser(userId: $userId, albumId: $albumId, rankDate: $rankDate, rankState: $rankState)';
  }
}
