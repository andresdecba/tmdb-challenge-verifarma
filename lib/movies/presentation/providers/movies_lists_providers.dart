import 'dart:async';

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

  int currentPage = 0;
  bool isLoading = false;
  Timer? _debounceTimer;

  Future<void> nextPage() async {
    if (isLoading) {
      return;
    } else {
      // debounce Call //
      _cancelTimer();
      _debounceTimer = Timer(
        const Duration(milliseconds: 666),
        () async {
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
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  void _cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }
}
