import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, List<MovieCategory>>> call() {
    return repository.getCategories();
  }
}
