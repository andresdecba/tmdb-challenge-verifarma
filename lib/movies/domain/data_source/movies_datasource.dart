import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getMovies({required int page, required String moviesList});
  //Future<Movie> getMovieById({required String id});
}
