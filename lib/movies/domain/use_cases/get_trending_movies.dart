import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetTrendingMoviesUseCase {
  const GetTrendingMoviesUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, List<Movie>>> call({required int page}) {
    return repository.getTrendingMovies(page: page);
  }
}
