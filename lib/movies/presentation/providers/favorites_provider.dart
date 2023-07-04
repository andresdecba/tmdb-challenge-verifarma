import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movie_usecase.dart';

// page > provider > usecase > domain-repository > data-repositoryImpl > domain-datasource > domain-datasourceImpl

// dependencias
final storageProvider = Provider<StorageDatasource>((ref) {
  return StorageDatasourceImpl();
});

final useCaseProvider = Provider<GetMovieUseCase>((ref) {
  return GetMovieUseCase(MovieRepositoryImpl(MoviesDatasourceImpl()));
});

// provider
final favoriteProviderAsync = StateNotifierProvider<FavoriteProviderController, AsyncValue<List<Movie>>>((ref) {
  return FavoriteProviderController(ref);
});

class FavoriteProviderController extends StateNotifier<AsyncValue<List<Movie>>> {
  FavoriteProviderController(this.ref) : super(const AsyncValue.loading()) {
    [];
  }

  final Ref ref;
  void getFavorites() async {
    state = const AsyncValue.loading();

    final storage = ref.read(storageProvider);
    final useCase = ref.read(useCaseProvider);
    List<String> favs = storage.getFavorites();
    List<Movie> devolver = [];

    for (var element in favs) {
      final result = await useCase.call(movieId: element);
      result.fold(
        (failure) {
          failure.showError();
          //state = AsyncValue.error(failure, StackTrace.current);
        },
        (data) {
          devolver.add(data);
        },
      );
    }
    state = AsyncValue.data(devolver);
  }

  void remove(Movie movie) {
    if (state.value == null) return;
    state.value!.remove(movie);
    state = AsyncValue.data(state.value!);
  }

  void add(Movie movie) {
    if (state.value == null) return;
    state.value!.add(movie);
    state = AsyncValue.data(state.value!);
  }
}
