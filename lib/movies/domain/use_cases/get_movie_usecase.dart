import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetMovieUseCase {
  const GetMovieUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, Movie>> call({required String movieId}) {
    return repository.getMovie(movieId: movieId);
  }
}
