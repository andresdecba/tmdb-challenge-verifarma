import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movies_list_usecase.dart';

// NOW PLAYING //
final nowPlayingProvider = StateNotifierProvider<GetMoviesListController, List<Movie>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'now_playing',
  );

  return GetMoviesListController(useCase: useCase);
});

// POPULAR //
final popularProvider = StateNotifierProvider<GetMoviesListController, List<Movie>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'popular',
  );

  return GetMoviesListController(useCase: useCase);
});

// TOP RATING //
final topRatedProvider = StateNotifierProvider<GetMoviesListController, List<Movie>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'top_rated',
  );

  return GetMoviesListController(useCase: useCase);
});

// UPCOMING //
final upcomingProvider = StateNotifierProvider<GetMoviesListController, List<Movie>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'upcoming',
  );

  return GetMoviesListController(useCase: useCase);
});

// PROVIDERS CONTROLLER //
class GetMoviesListController extends StateNotifier<List<Movie>> {
  GetMoviesListController({
    required this.useCase,
  }) : super([]);

  GetMoviesListUseCase useCase;

  int currentPage = 1;
  bool isLoading = false;

  Future<void> nextPage() async {
    if (isLoading) {
      return;
    } else {
      isLoading = true;
      currentPage++;
      final result = await useCase.call(page: currentPage);
      result.fold(
        (failure) {
          failure.showError();
        },
        (data) {
          state = [...state, ...data];
        },
      );
      isLoading = false;
    }
  }
}
