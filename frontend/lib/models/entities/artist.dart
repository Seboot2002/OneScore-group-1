class Artist {
  final int artistId;
  final String name;
  final int genreId;
  final String pictureUrl;
  final int debutYear;

  Artist({
    required this.artistId,
    required this.name,
    required this.genreId,
    required this.pictureUrl,
    required this.debutYear,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['artistId'],
      name: json['name'],
      genreId: json['genreId'],
      pictureUrl: json['pictureUrl'],
      debutYear: json['debutYear'],
    );
  }

  factory Artist.fromSearchJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['id'],
      name: json['name'],
      genreId: 0, // No lo incluye la búsqueda
      pictureUrl: json['picture_url'],
      debutYear: 0, // No lo incluye la búsqueda
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'name': name,
      'genreId': genreId,
      'pictureUrl': pictureUrl,
      'debutYear': debutYear,
    };
  }

  @override
  String toString() {
    return 'Artist(artistId: $artistId, name: $name, genreId: $genreId, pictureUrl: $pictureUrl, debutYear: $debutYear)';
  }
}
