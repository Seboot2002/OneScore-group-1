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
