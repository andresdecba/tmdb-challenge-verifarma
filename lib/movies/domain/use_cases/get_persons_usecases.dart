import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class GetPersonsUseCase {
  const GetPersonsUseCase(
    this.repository,
  );

  final MoviesRepository repository;

  Future<Either<Failure, List<PersonDetails>>> call({required String query, required int page}) {
    return repository.getPersons(query: query, page: page);
  }
}
