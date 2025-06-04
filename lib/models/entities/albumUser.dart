class AlbumUser {
  final int userId;
  final int albumId;
  final String rankDate;
  final String rankState;

  AlbumUser({
    required this.userId,
    required this.albumId,
    required this.rankDate,
    required this.rankState,
  });

  factory AlbumUser.fromJson(Map<String, dynamic> json) {
    return AlbumUser(
      userId: json['userId'],
      albumId: json['albumId'],
      rankDate: json['rankDate'],
      rankState: json['rankState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'albumId': albumId,
      'rankDate': rankDate,
      'rankState': rankState,
    };
  }

  // Método para obtener el año de la fecha
  int get listenYear {
    DateTime date = DateTime.parse(rankDate);
    return date.year;
  }

  @override
  String toString() {
    return 'AlbumUser(userId: $userId, albumId: $albumId, rankDate: $rankDate, rankState: $rankState)';
  }
}
