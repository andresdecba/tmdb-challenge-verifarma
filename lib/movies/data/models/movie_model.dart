import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required adult,
    required backdropPath,
    required genreIds,
    required id,
    required originalLanguage,
    required originalTitle,
    required overview,
    required popularity,
    required posterPath,
    required releaseDate,
    required title,
    required video,
    required voteAverage,
    required voteCount,
  }) : super(
          adult: adult,
          backdropPath: backdropPath,
          genreIds: genreIds,
          id: id,
          originalLanguage: originalLanguage,
          originalTitle: originalTitle,
          overview: overview,
          popularity: popularity,
          posterPath: posterPath,
          releaseDate: releaseDate,
          title: title,
          video: video,
          voteAverage: voteAverage,
          voteCount: voteCount,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        adult: json["adult"] ?? false,
        //
        backdropPath: json["backdrop_path"] != null ? 'https://image.tmdb.org/t/p/w500${json["backdrop_path"]}' : '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble(),
        //
        posterPath: json["poster_path"] != null ? 'https://image.tmdb.org/t/p/w500${json["poster_path"]}' : '',
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
