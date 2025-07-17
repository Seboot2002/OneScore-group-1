class Album {
  final int albumId;
  final String title;
  final int releaseYear;
  final int genreId;
  final String coverUrl;
  final int artistId;

  Album({
    required this.albumId,
    required this.title,
    required this.releaseYear,
    required this.genreId,
    required this.coverUrl,
    required this.artistId,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['albumId'] ?? 0,
      title: json['title'] ?? '',
      releaseYear: json['releaseYear'] ?? 0,
      genreId: json['genreId'] ?? 0,
      coverUrl: json['coverUrl'] ?? '',
      artistId: json['artistId'] ?? 0,
    );
  }

  /// ✅ Constructor alternativo solo para resultados de búsqueda
  factory Album.fromSearchJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['id'] ?? 0,
      title: json['title'] ?? '',
      releaseYear: 0,
      genreId: 0,
      coverUrl: json['cover_url'] ?? '',
      artistId: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'title': title,
      'releaseYear': releaseYear,
      'genreId': genreId,
      'coverUrl': coverUrl,
      'artistId': artistId,
    };
  }

  @override
  String toString() {
    return 'Album(albumId: $albumId, title: $title, releaseYear: $releaseYear, genreId: $genreId, coverUrl: $coverUrl, artistId: $artistId)';
  }
}
