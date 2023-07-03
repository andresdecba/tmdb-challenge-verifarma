import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getMoviesList({required int page, required String moviesList});
  Future<Either<Failure, List<Movie>>> searchMovies({required String query});
  Future<Either<Failure, Movie>> getMovie({required String movieId});
}
