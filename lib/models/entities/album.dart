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
      albumId: json['albumId'],
      title: json['title'],
      releaseYear: json['releaseYear'],
      genreId: json['genreId'],
      coverUrl: json['coverUrl'],
      artistId: json['artistId'],
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
