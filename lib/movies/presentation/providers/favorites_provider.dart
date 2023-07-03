import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_details.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movie_usecase.dart';

// page > provider > usecase > domain-repository > data-repositoryImpl > domain-datasource > domain-datasourceImpl

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

  void saveFavorite(String value) {
    storage.saveFavorite(value);
  }

  void removeFavorite(int value) {
    storage.removeFavorite(value);
  }

  Future<List<Movie>> getFavorites() async {
    List<String> favs = storage.getFavorites();
    List<Movie> list = [];

    if (favs.isEmpty) {
      return list;
    }

    for (var element in favs) {
      final result = await useCase.call(movieId: element);
      result.fold(
        (failure) {
          null;
          print('holiiisa fail $failure');
        },
        (data) {
          list.add(data);
        },
      );
    }
    print('holiiisa $list');
    return list;
  }

  // List<String> getFavorites() {
  //   return storage.getFavorites();
  // }

  //var ids = ['697843', '569094', '502356', '667538', '986070'];

  // 1- traer los ids guardados localmente

  // 2- hacer for con llamadas al servidor obteniendo las pelis

  // 3- iniciar el metodo de arriba en el initState
}
