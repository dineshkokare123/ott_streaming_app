class Content {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;
  final String mediaType; // 'movie' or 'tv'
  final List<int>? genreIds;
  final double? popularity;
  final String? originalLanguage;
  final bool? adult;

  Content({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    required this.mediaType,
    this.genreIds,
    this.popularity,
    this.originalLanguage,
    this.adult,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Unknown',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      releaseDate: json['release_date'] ?? json['first_air_date'],
      mediaType: json['media_type'] ?? 'movie',
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      popularity: json['popularity']?.toDouble(),
      originalLanguage: json['original_language'],
      adult: json['adult'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'media_type': mediaType,
      'genre_ids': genreIds,
      'popularity': popularity,
      'original_language': originalLanguage,
      'adult': adult,
    };
  }

  String get rating =>
      voteAverage != null ? voteAverage!.toStringAsFixed(1) : 'N/A';

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return 'N/A';
    return releaseDate!.split('-')[0];
  }

  bool get isMovie => mediaType == 'movie';
}
