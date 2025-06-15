class ArtistUser {
  final int userId;
  final int artistId;

  ArtistUser({required this.userId, required this.artistId});

  factory ArtistUser.fromJson(Map<String, dynamic> json) {
    return ArtistUser(userId: json['userId'], artistId: json['artistId']);
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'artistId': artistId};
  }

  @override
  String toString() {
    return 'ArtistUser(userId: $userId, artistId: $artistId)';
  }
}
