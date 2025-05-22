class Songuser {
  final int userId;
  final int songId;
  final int score;

  Songuser({required this.userId, required this.songId, required this.score});

  factory Songuser.fromJson(Map<String, dynamic> json) {
    return Songuser(
      userId: json['userId'],
      songId: json['songId'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'songId': songId, 'score': score};
  }

  @override
  String toString() {
    return 'SongUser(userId: $userId, songId: $songId, score: $score)';
  }
}
