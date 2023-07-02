import 'package:tmdb_challenge/movies/data/models/tmdb_movie_model.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

class MovieMapper {
  static Movie movieMapper(TMDBMovieModel movieDB) {
    return Movie(
      id: movieDB.id,
      adult: movieDB.adult ?? false,
      backdropPath: (movieDB.backdropPath != null) ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' : null,
      genreIds: movieDB.genreIds ?? _noGenreIds,
      originalLanguage: movieDB.originalLanguage ?? '',
      originalTitle: movieDB.originalTitle ?? '',
      overview: movieDB.overview ?? '',
      popularity: movieDB.popularity ?? 0.0,
      posterPath: (movieDB.posterPath != null) ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' : null,
      releaseDate: (movieDB.releaseDate != null) ? DateTime.parse(movieDB.releaseDate!) : null,
      title: movieDB.title ?? '',
      video: movieDB.video ?? false,
      voteAverage: movieDB.voteAverage ?? 0.0,
      voteCount: movieDB.voteCount ?? 0,
    );
  }
}

const String _noPoster = 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
const List<int> _noGenreIds = [];
