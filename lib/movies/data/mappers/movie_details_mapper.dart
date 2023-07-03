import 'package:tmdb_challenge/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_details.dart';

class MovieDetailsMapper {
  static MovieDetails movieMapper(MovieDetailsModel movie) {
    return MovieDetails(
      id: movie.id,
      overview: movie.overview ?? '',
      posterPath: movie.posterPath ?? '',
      title: movie.title ?? '',
      voteAverage: movie.voteAverage ?? 0.0,
    );
  }
}
