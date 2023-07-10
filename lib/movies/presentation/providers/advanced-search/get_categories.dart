import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_categories_usecase.dart';

// OBTENER CATEGORIAS PROVIDER
final getCategoriesProvider = FutureProvider<List<MovieCategory>>((ref) async {
  final useCase = GetCategoriesUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  List<MovieCategory> value = [];
  var result = await useCase.call();
  result.fold(
    (failure) {
      //AsyncValue.error(failure, StackTrace.current);
      failure.showError();
    },
    (data) {
      //AsyncValue.data(data);
      value = data;
    },
  );
  return value;
});

// LISTA
final selectedCategProvider = StateProvider<List<MovieCategory>>((ref) {
  return [];
});
