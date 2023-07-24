import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class SearchMoviesByTitleUseCase {
  const SearchMoviesByTitleUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, MoviesList>> call({
    required String query,
    required int page,
  }) {
    return repository.searchMoviesByTitle(query: query, page: page);
  }
}
