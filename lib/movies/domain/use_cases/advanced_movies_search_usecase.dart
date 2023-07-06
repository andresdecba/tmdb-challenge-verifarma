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
    String? keyWord,
    DateTime? fromYear,
    DateTime? toYear,
    int? year,
    String? people,
    String? category,
  }) {
    return repository.advancedMoviesSearch(
      category: category,
      fromYear: fromYear,
      keyWord: keyWord,
      people: people,
      toYear: toYear,
      year: year,
    );
  }
}
