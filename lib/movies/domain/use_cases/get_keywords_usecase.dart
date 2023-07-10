import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/keyword.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetKeywordsUseCase {
  const GetKeywordsUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, List<Keyword>>> call({required String query, required int page}) {
    return repository.getKeywords(query: query, page: page);
  }
}
