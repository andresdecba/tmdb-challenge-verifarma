import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movie_usecase.dart';

// page > provider > usecase > domain-repository > data-repositoryImpl > domain-datasource > domain-datasourceImpl

///////////////////////// dependencias

final storageProvider = Provider<StorageDatasource>((ref) {
  return StorageDatasourceImpl();
});

final useCaseProvider = Provider<GetMovieUseCase>((ref) {
  return GetMovieUseCase(MovieRepositoryImpl(MoviesDatasourceImpl()));
});

//////////////////////////////// opt 1
final seeeeeeeeeee = StateNotifierProvider<CondominioNotifier, AsyncValue<List<Movie>>>((ref) {
  return CondominioNotifier(ref);
});

class CondominioNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  CondominioNotifier(this.ref) : super(const AsyncValue.loading()) {
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
    ref.read(esto.notifier).update((state) => devolver);
    state = AsyncValue.data(devolver);
  }
}
////////

final esto = StateProvider<List<Movie>>((ref) => []);

///////////////////////// op 2

final porfaaaaAhoraSi = FutureProvider<List<Movie>>((ref) {
  final storage = ref.read(storageProvider);
  final useCase = ref.read(useCaseProvider);

  Future<List<Movie>> getFavorites() async {
    List<String> favs = storage.getFavorites();
    final List<Movie> getalgo = [];

    if (favs.isEmpty) {
      return getalgo;
    }
    getalgo.clear();
    for (var element in favs) {
      final result = await useCase.call(movieId: element);
      result.fold(
        (failure) {
          failure.showError();
        },
        (data) {
          getalgo.add(data);
        },
      );
    }
    return getalgo;
  }

  return getFavorites();
});

///////////////////////////////// opt 3

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
