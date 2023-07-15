import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movies_list_usecase.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_trending_movies.dart';

final moviesListPreview = FutureProvider.autoDispose.family<MoviesList?, String>((ref, list) async {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    list,
  );

  final result = await useCase.call(page: 1);
  return result.fold(
    (failure) {
      failure.showError();
      return null;
    },
    (data) {
      return data;
    },
  );
});

final tendingMoviesPreview = FutureProvider.autoDispose<List<Movie>?>((ref) async {
  final useCase = GetTrendingMoviesUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  final result = await useCase.call(page: 1);
  return result.fold(
    (failure) {
      failure.showError();
      return null;
    },
    (data) {
      return data;
    },
  );
});
