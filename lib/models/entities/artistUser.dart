class ArtistUser {
  final int userId;
  final int artistId;

  ArtistUser({required this.userId, required this.artistId});

  // Factory constructor para crear una instancia de ArtistUser desde un Map (JSON)
  factory ArtistUser.fromJson(Map<String, dynamic> json) {
    return ArtistUser(userId: json['userId'], artistId: json['artistId']);
  }

  // Método para convertir una instancia de ArtistUser a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'artistId': artistId};
  }

  // Sobrescribe el método toString para una representación de cadena legible
  @override
  String toString() {
    return 'ArtistUser(userId: $userId, artistId: $artistId)';
  }
}
