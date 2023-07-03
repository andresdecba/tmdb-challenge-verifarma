import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movie_usecase.dart';

// page > provider > usecase > domain-repository > data-repositoryImpl > domain-datasource > domain-datasourceImpl

// get from DB
final favoritesProvider = StateNotifierProvider<GetFavotitesController, List<Movie>>((ref) {
  final storage = StorageDatasourceImpl();
  final useCase = GetMovieUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  return GetFavotitesController(storage, useCase);
});

class GetFavotitesController extends StateNotifier<List<Movie>> {
  GetFavotitesController(this.storage, this.useCase) : super([]);

  StorageDatasource storage;
  GetMovieUseCase useCase;

  Future<List<Movie>> getFavorites() async {
    List<String> favs = storage.getFavorites();
    if (favs.isEmpty) {
      return state;
    }
    state.clear();
    for (var element in favs) {
      final result = await useCase.call(movieId: element);
      result.fold(
        (failure) {
          failure.showError();
        },
        (data) {
          state.add(data);
        },
      );
    }
    return state;
  }
}
