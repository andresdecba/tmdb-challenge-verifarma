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
    required String people,
    required String category,
  }) {
    return repository.advancedMoviesSearch(
      category: category != '' ? category : null,
      fromYear: fromYear != '' ? fromYear : null,
      keyWord: keyWord != '' ? keyWord : null,
      people: people != '' ? people : null,
      toYear: toYear != '' ? toYear : null,
      year: year != '' ? int.parse(year) : null,
    );
  }
}
