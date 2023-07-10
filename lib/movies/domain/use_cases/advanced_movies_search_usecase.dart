import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class AdvancedMoviesSearchUseCase {
  const AdvancedMoviesSearchUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, AdvancedMoviesSearch>> call({
    required String keyWord,
    required String fromYear,
    required String toYear,
    required String year,
    required String persons,
    required String categories,
  }) {
    return repository.advancedMoviesSearch(
      categories: categories != '' ? categories : null,
      fromYear: fromYear != '' ? fromYear : null,
      keyWord: keyWord != '' ? keyWord : null,
      persons: persons != '' ? persons : null,
      toYear: toYear != '' ? toYear : null,
      year: year != '' ? int.parse(year) : null,
    );
  }
}
