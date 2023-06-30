import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetMoviesListUseCase {
  const GetMoviesListUseCase(
    this.repository,
    this.moviesList,
  );

  final MoviesRepository repository;
  final String moviesList;

  Future<Either<Failure, List<Movie>>> call({required int page}) {
    return repository.getMoviesList(page: page, moviesList: moviesList);
  }
}
