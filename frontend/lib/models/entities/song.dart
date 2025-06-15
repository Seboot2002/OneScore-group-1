class Song {
  final int songId;
  final String title;
  final int nTrack;
  final int albumId;

  Song({
    required this.songId,
    required this.title,
    required this.nTrack,
    required this.albumId,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['songId'],
      title: json['title'],
      nTrack: json['nTrack'],
      albumId: json['albumId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'title': title,
      'nTrack': nTrack,
      'albumId': albumId,
    };
  }

  @override
  String toString() {
    return 'Song(songId: $songId, title: $title, nTrack: $nTrack, albumId: $albumId)';
  }
}
