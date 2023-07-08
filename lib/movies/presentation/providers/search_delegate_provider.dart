import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/search_movies_usecase.dart';

final searchMoviesProvider = Provider<SearchMoviesUseCase>((ref) {
  return SearchMoviesUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );
});
