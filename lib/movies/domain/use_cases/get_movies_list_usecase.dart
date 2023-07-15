import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetMoviesListUseCase {
  const GetMoviesListUseCase(
    this.repository,
    this.moviesList,
  );

  final MoviesRepository repository;
  final String moviesList;

  Future<Either<Failure, MoviesList>> call({required int page}) {
    return repository.getMoviesList(page: page, moviesList: moviesList);
  }
}
